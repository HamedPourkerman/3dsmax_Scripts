using System;
using System.Collections.Generic;
using System.Text;
using System.Reflection;
using System.Reflection.Emit;
using System.ComponentModel;
using System.Threading;
using System.Drawing.Design;

namespace UiFramworkLibrary
{
    public static class ObjectWrapperFactory
    {
        // Method attributes for get_* set_* methods (property accessors)
        private static readonly MethodAttributes getSetAttr = MethodAttributes.Public | MethodAttributes.SpecialName | MethodAttributes.HideBySig;

        public static ObjectWrapper CreateWrapper(object instance)
        {
            return InternalCreateWrapper(instance, null, false); 
        }

        public static ObjectWrapper CreateWrapperWithVisibleProperties(object instance, string[] propertyNames)
        {
            if (propertyNames == null)
                propertyNames = new string[] { }; 

            return InternalCreateWrapper(instance, propertyNames, true);
        }

        public static ObjectWrapper CreateWrapperWithHiddenProperties(object instance, string[] propertyNames)
        {
            if (propertyNames == null)
                propertyNames = new string[] { }; 

            return InternalCreateWrapper(instance, propertyNames, false);
        }

        private static ObjectWrapper InternalCreateWrapper(object instance, string[] propertyNames, bool makeVisible)
        {
            if (instance == null)
                throw new ArgumentNullException("instance"); 

            // Create assembly to hold generated wrapper type
            AssemblyName assemblyName = new AssemblyName("ObjectWrapperAssembly");
            AssemblyBuilder assemblyBuilder = Thread.GetDomain().DefineDynamicAssembly(assemblyName, AssemblyBuilderAccess.RunAndSave);

            // Create module to store Type information in
            ModuleBuilder moduleBuilder = assemblyBuilder.DefineDynamicModule("ObjectWrapperModule.dll");

            // Start creating object wrapper type
            TypeBuilder wrapperClass = moduleBuilder.DefineType("GeneratedClasses.ObjectWrapper", TypeAttributes.Public);
                        
            // Add field to keep reference to wrapped object instance 
            FieldBuilder wrappedInstanceField = wrapperClass.DefineField("wrappedInstance", instance.GetType(), FieldAttributes.Private);

            // Create constructor, that takes wrapped object instance as parameter
            CreateConstructor(wrappedInstanceField, wrapperClass, instance); 

            // Create properties, that are wrappers for instance object properties
            PropertyInfo[] propertyCollection = instance.GetType().GetProperties();

            if (propertyCollection != null)
                foreach (PropertyInfo p in propertyCollection)
                {
                    if (propertyNames == null)
                    {
                        CreateProperty(p, wrapperClass, wrappedInstanceField);
                    }
                    else
                    {
                        if (makeVisible)
                        {
                            if (ContainsName(propertyNames, p.Name))
                                CreateProperty(p, wrapperClass, wrappedInstanceField);
                        }
                        else
                        {
                            if (!ContainsName(propertyNames, p.Name))
                                CreateProperty(p, wrapperClass, wrappedInstanceField);
                        }
                    }
                }

            // Build the System.Type 
            Type wrapperType = wrapperClass.CreateType();
            //((AssemblyBuilder)wrapperType.Assembly).Save("ObjectWrapperModule.dll"); 
            
            // Create wrapper object instance
            object wrapper = Activator.CreateInstance(wrapperType, instance);
            return new ObjectWrapper(instance, wrapper); 
        }

        private static void CreateConstructor(FieldBuilder instanceField, TypeBuilder typeBuilder, object instance)
        {
            // Add constructor to take wrapped instance as parameter
            Type[] constructorArguments = { instance.GetType() };
            ConstructorBuilder constructor = typeBuilder.DefineConstructor(MethodAttributes.Public, CallingConventions.Standard, constructorArguments);

            // The constructor calls its superclass constructor. The constructor stores its argument in the private field.
            ILGenerator constructorIL = constructor.GetILGenerator();

            ConstructorInfo superConstructor = typeof(Object).GetConstructor(Type.EmptyTypes);

            constructorIL.Emit(OpCodes.Ldarg_0);
            constructorIL.Emit(OpCodes.Call, superConstructor);
            constructorIL.Emit(OpCodes.Ldarg_0);
            constructorIL.Emit(OpCodes.Ldarg_1);
            constructorIL.Emit(OpCodes.Stfld, instanceField);
            constructorIL.Emit(OpCodes.Ret);
        }

        private static void CreateProperty(PropertyInfo propertyInfo, TypeBuilder typeBuilder, FieldBuilder instanceField)
        {
            // Build wrapper properties, that are mapped to wrapped object properties
            PropertyBuilder wrappedInstancePropBldr = typeBuilder.DefineProperty(propertyInfo.Name,
                                                         propertyInfo.Attributes,
                                                         propertyInfo.PropertyType,
                                                         null
                                                         );

            // Create property getters
            CreatePropertyGetter(propertyInfo, wrappedInstancePropBldr, typeBuilder, instanceField);

            // Create property setters
            CreatePropertySetter(propertyInfo, wrappedInstancePropBldr, typeBuilder, instanceField);

            // Create property attributes to display them correctly in the property grid
            CreateCustomAttributes(propertyInfo, wrappedInstancePropBldr);
        }

        private static void CreatePropertyGetter(PropertyInfo propertyInfo, PropertyBuilder propertyBuilder, TypeBuilder typeBuilder, FieldBuilder instanceField)
        {
            if (propertyInfo.GetGetMethod() == null)
                return;

            MethodBuilder wrappedInstanceGetPropMthdBldr =
                typeBuilder.DefineMethod("get_" + propertyInfo.Name,
                                           getSetAttr,
                                           propertyInfo.PropertyType,
                                           Type.EmptyTypes);

            // Method invokes get_* method of the wrapped class. 
            ILGenerator wrappedInstanceGetIL = wrappedInstanceGetPropMthdBldr.GetILGenerator();

            wrappedInstanceGetIL.Emit(OpCodes.Ldarg_0);
            wrappedInstanceGetIL.Emit(OpCodes.Ldfld, instanceField);
            wrappedInstanceGetIL.Emit(OpCodes.Callvirt, propertyInfo.GetGetMethod());
            wrappedInstanceGetIL.Emit(OpCodes.Ret);

            propertyBuilder.SetGetMethod(wrappedInstanceGetPropMthdBldr);
        }

        private static void CreatePropertySetter(PropertyInfo propertyInfo, PropertyBuilder propertyBuilder, TypeBuilder typeBuilder, FieldBuilder instanceField)
        {
            if (propertyInfo.GetSetMethod() == null)
                return;

            MethodBuilder wrappedInstanceSetPropMthdBldr =
                typeBuilder.DefineMethod("set_" + propertyInfo.Name,
                                           getSetAttr,
                                           null,
                                           new Type[] { propertyInfo.PropertyType });

            // Method invokes set_* method of the wrapped class. 
            ILGenerator wrappedInstanceSetIL = wrappedInstanceSetPropMthdBldr.GetILGenerator();

            wrappedInstanceSetIL.Emit(OpCodes.Ldarg_0);
            wrappedInstanceSetIL.Emit(OpCodes.Ldfld, instanceField);
            wrappedInstanceSetIL.Emit(OpCodes.Ldarg_1);
            wrappedInstanceSetIL.Emit(OpCodes.Callvirt, propertyInfo.GetSetMethod());
            wrappedInstanceSetIL.Emit(OpCodes.Ret);

            propertyBuilder.SetSetMethod(wrappedInstanceSetPropMthdBldr);
        }

        private static void CreateCustomAttributes(PropertyInfo propertyInfo, PropertyBuilder propertyBuilder)
        {
            Array customAttributes = propertyInfo.GetCustomAttributes(true);
            ConstructorInfo ctor = null;
            object[] ctorArgs = null;

            // In order for properties to be displayed properly inside the property grid
            // it is necessary to set appropriate BrowsableAttribute, DescriptionAttribute, CategoryAttribute,
            // DisplayNameAttribute attribute values (could be more attributes applicable). 
            if (customAttributes != null)
                foreach (Attribute attribute in customAttributes)
                {
                    ctor = null;
                    ctorArgs = null; 

                    if (attribute is BrowsableAttribute)
                    {
                        BrowsableAttribute a = attribute as BrowsableAttribute;
                        ctor = typeof(BrowsableAttribute).GetConstructor(new Type[] { typeof(bool) });
                        ctorArgs = new object[] { a.Browsable };
                    }

                    if (attribute is DescriptionAttribute)
                    {
                        DescriptionAttribute a = attribute as DescriptionAttribute;
                        ctor = typeof(DescriptionAttribute).GetConstructor(new Type[] { typeof(string) });
                        ctorArgs = new object[] { a.Description };
                    }

                    if (attribute is CategoryAttribute)
                    {
                        CategoryAttribute a = attribute as CategoryAttribute;
                        ctor = typeof(CategoryAttribute).GetConstructor(new Type[] { typeof(string) });
                        ctorArgs = new object[] { a.Category };
                    }

                    if (attribute is DisplayNameAttribute)
                    {
                        DisplayNameAttribute a = attribute as DisplayNameAttribute;
                        ctor = typeof(DisplayNameAttribute).GetConstructor(new Type[] { typeof(string) });
                        
                        ctorArgs = new object[] { a.DisplayName };
                    }

                    if (attribute is EditorAttribute)
                    {
                        EditorAttribute a = attribute as EditorAttribute;
                        ctor = typeof(EditorAttribute).GetConstructor(new Type[] { typeof(string) });

                        ctorArgs = new object[] { a.EditorTypeName };
                    }

                    if (ctor != null && ctorArgs != null)
                        propertyBuilder.SetCustomAttribute(new CustomAttributeBuilder(ctor, ctorArgs));
                }

            // Property grid by default does not allow editing object properties, but sometimes it is necessary
            // to fill in value as a string (i.e. when filling System.Windows.Control.ContentControl.Content value
            // for Windows Presentation Foundation ContentControl). For that purpose we add 
            // TypeConverter(typeof(StringConverter)) attribute to such properties. 
            if (propertyInfo.PropertyType.Equals(typeof(object)))
            {
                TypeConverterAttribute a = new TypeConverterAttribute();
                ctor = typeof(TypeConverterAttribute).GetConstructor(new Type[] { typeof(System.Type) });
                ctorArgs = new object[] { typeof(StringConverter) };
                propertyBuilder.SetCustomAttribute(new CustomAttributeBuilder(ctor, ctorArgs));
            }
        }

        private static bool ContainsName(string[] names, string nameToFind)
        {
            foreach (string name in names)
            {
                if (name == nameToFind)
                    return true; 
            }

            return false; 
        }
    }

    // Class that stores both references to a real object instance and its wrapper. 
    public class ObjectWrapper
    {
        private object _wrappedInstance;

        public object WrappedInstance
        {
            get { return _wrappedInstance; }
        }

        private object _wrapper;

        public object Wrapper
        {
            get { return _wrapper; }
        }

        public ObjectWrapper(object element, object wrappedElement)
        {
            if (element == null)
                throw new ArgumentNullException("element");

            if (wrappedElement == null)
                throw new ArgumentNullException("wrappedElement");

            _wrappedInstance = element;
            _wrapper = wrappedElement; 
        }

        public bool Contains(object element)
        {
            if (element == null)
                return false; 

            return (element == _wrappedInstance); 
        }
    }
}
