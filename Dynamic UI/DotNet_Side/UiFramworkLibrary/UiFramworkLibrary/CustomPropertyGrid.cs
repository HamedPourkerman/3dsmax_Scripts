using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;
using System.Drawing.Design;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Windows.Forms.Design;

namespace UiFramworkLibrary
{
    public partial class MultilineTextEditor : UITypeEditor
    {
        private IWindowsFormsEditorService _editorService;
        public override UITypeEditorEditStyle GetEditStyle(ITypeDescriptorContext context)
        {
            return UITypeEditorEditStyle.DropDown;
        }
        public override object EditValue(ITypeDescriptorContext context, IServiceProvider provider, object value)
        {
            _editorService = (IWindowsFormsEditorService)provider.GetService(typeof(IWindowsFormsEditorService));

            TextBox textEditorBox = new TextBox();
            textEditorBox.Multiline = true;
            textEditorBox.ScrollBars = ScrollBars.Both;
            textEditorBox.Width = 400;
            textEditorBox.Height = 400;
            textEditorBox.BorderStyle = BorderStyle.None;
            textEditorBox.AcceptsReturn = true;
            textEditorBox.Text = value as string;

            _editorService.DropDownControl(textEditorBox);

            return textEditorBox.Text;
        }
    }
    public partial class CustomPropertyGrid : PropertyGrid
    {
        private string itags = string.Empty;
        [Editor(typeof(MultilineTextEditor), typeof(UITypeEditor))]
        
        public string ITags
        {
            get { return itags; }
            set { itags = value; }
        }
    }
    //public partial class custompropertygrid : component
    //{
    //    public custompropertygrid()
    //    {
    //        initializecomponent();
    //    }

    //    public custompropertygrid(icontainer container)
    //    {
    //        container.add(this);

    //        initializecomponent();
    //    }
    //}
}
