using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Drawing.Design;
using System.Drawing.Drawing2D;
using System.Linq;
using System.Runtime.Remoting;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Windows.Forms.Design;
using System.Windows.Forms.Layout;

namespace UiFramworkLibrary
{
    /// <summary>
    /// Multiline Control For Propertygrid
    /// </summary>

    public partial class GraphicButton : Button
    {
        
        #region private Values
            private string buttonType = "Circle";
            Color InsideColorTemp, BorderColorTemp;
            private Color textColor = Color.White;
            private Color insideColor = Color.Blue;
            private Color bordercolor = Color.Yellow;
            private Color m_hovercolor1;     //Inside Mouse Hover Color
            private Color m_hovercolor2;     //Border Mouse Hover Color
            private Color clickcolor1;       //Inside Mouse Click Color
            private Color clickcolor2;       //Border Mouse Click Color
            private int color1Transparent = 255;
            private int color2Transparent = 255;
            private int angle = 180;
            private int textX;
            private int textY;
            private int borderThick;
            private String text = "";
            private bool isSelected = false;
            private int radiusRoundRect = 30;
        #endregion
        #region Constructors
            public GraphicButton()
        {
            SetStyle(ControlStyles.SupportsTransparentBackColor, true);
            SetStyle(ControlStyles.UserPaint, true);

            this.Size = new System.Drawing.Size(100, 100);
            this.ForeColor = Color.Yellow;
            this.BackColor = Color.Transparent;
            this.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.FlatAppearance.BorderColor = Color.FromArgb(255, 0, 255, 0);
            //this.FlatAppearance.BorderSize = 5;
            text = this.Text;
            this.BorderThick = 5;
            HCThick = 20;


            //OnIsselectedChanged
        }
        #endregion
        #region Private Properties
            /*private String DisplayText
            {
                get { return text; }
                set { text = value; Invalidate(); }
            }*/
            private Color InsideColor
            {
                get { return insideColor; }
                set { insideColor = value; Invalidate(); }
            }
            private Color BorderColor
            {
                get { return bordercolor; }
                set { bordercolor = value; Invalidate(); }
            }
            private Color MouseHoverInsideColor
            {
                get { return m_hovercolor1; }
                set { m_hovercolor1 = value; Invalidate(); }
            }
            private Color MouseHoverBorderColor
            {
                get { return m_hovercolor2; }
                set { m_hovercolor2 = value; Invalidate(); }
            }
            private Color MouseClickInsideColor
            {
                get { return clickcolor1; }
                set { clickcolor1 = value; Invalidate(); }
            }
            private Color MouseClickBorderColor
            {
                get { return clickcolor2; }
                set { clickcolor2 = value; Invalidate(); }
            }
            private int TransparentInsideColor
            {
                get { return color1Transparent; }
                set
                {
                    color1Transparent = value;
                    if (color1Transparent > 255)
                    {
                        color1Transparent = 255;
                        Invalidate();
                    }
                    else
                        Invalidate();
                }
            }
            private int TransparentBorderColor
            {
                get { return color2Transparent; }
                set
                {
                    color2Transparent = value;
                    if (color2Transparent > 255)
                    {
                        color2Transparent = 255;
                        Invalidate();
                    }
                    else
                        Invalidate();
                }
            }
            private int TextLocation_X
            {
                get { return textX; }
                set { textX = value; Invalidate(); }
            }
            private int TextLocation_Y
            {
                get { return textY; }
                set { textY = value; Invalidate(); }
            }
            private string Itag;
        #endregion
        #region Public Properties
        //Create Properties to read Button Text,Colors etc  

        // "Circle";"Curve";"Rectanlge";"HalfCircle";"RoundRectanlge"
            public enum ButtonTypeEnum
            {
                CircleButton = 1,
                CurveButton = 2,
                HalfCircleButton = 3,
                RectanlgeButton = 4,
                RoundRectanlgeButton = 5
            };
            private ButtonTypeEnum buttonTypeE = ButtonTypeEnum.CircleButton;
        [Browsable(false)] //Hide IsSelected From PropertyGrid
            public bool IsSelected
            {
                get { return isSelected; }
                set {isSelected = value;Invalidate();}
            }
            public int GradientAngle
            {
                get { return angle; }
                set { angle = value; Invalidate(); }
            }
            public int BorderThick
            {
                get { return borderThick; }
                set { borderThick = value; Invalidate(); }
            }
        [Browsable(false)]
            public string ButtonTypeSrting
            {
                get { return buttonType; }
            }
            public ButtonTypeEnum ButtonType
            {
                get { return buttonTypeE; }
                set
                {
                    buttonTypeE = value; Invalidate();
                    switch (buttonTypeE)
                    {
                        case ButtonTypeEnum.CircleButton: buttonType = "Circle"; Invalidate(); break;
                        case ButtonTypeEnum.CurveButton: buttonType = "Curve"; Invalidate(); break;
                        case ButtonTypeEnum.HalfCircleButton: buttonType = "HalfCircle"; Invalidate(); break;
                        case ButtonTypeEnum.RectanlgeButton: buttonType = "Rectanlge"; Invalidate(); break;
                        case ButtonTypeEnum.RoundRectanlgeButton: buttonType = "RoundRectanlge"; Invalidate(); break;
                        default:break;
                    }
                }
            }
            public int Radius
            {
                get { return radiusRoundRect; }
                set { radiusRoundRect = value;Invalidate(); }
            }
            public Color IBorderColors
            {
                get { return this.BackColor; }
                set { this.BackColor = value; Invalidate(); }
            }
            public Color IInsideColors
            {
                get { return this.ForeColor; }
                set { this.ForeColor = value; Invalidate(); }
            }
            public Color ITextColor
            {
                get { return textColor; }
                set { textColor = value; Invalidate(); }
            }
            public Size ButtonSize
            {
                get { return this.Size; }
                set { this.Size = value; }
            }
            public Point Position
            {
                get { return this.Location; }
                set { this.Location = value; }
            }
            public int ISizeWidth
        {
                get { return this.Size.Width; }
                set { this.Size = new Size (value,Size.Height); Invalidate(); }
            }
            public int ISizeHeight
        {
                get { return this.Size.Height; }
                set { this.Size = new Size(Size.Width,value); Invalidate(); }
            }
            public int PositionX
            {
                get { return this.Location.X; }
                set { this.Location = new Point(value,Location.Y); }
            }
            public int PositionY
            {
                get { return this.Location.Y; }
                set { this.Location = new Point(Location.X, value); }
            }
        
            public Color ISelectedColor
                {
                    get { return this.FlatAppearance.BorderColor; }
                    set { this.FlatAppearance.BorderColor = value; }
                }
            public string IText
        {
            get { return this.Text; }
            set { this.Text = value; }
        }
        
        private string itag = string.Empty;
        
        [CategoryAttribute("MaxScript")]
        [DescriptionAttribute("Execute MaxScript Code")]
        [Editor(typeof(MultilineTextEditor), typeof(UITypeEditor))]
        public string IMaxScript
        {
            get { return itag; }
            set { itag = value; }
        }
        /*public string ITag
        {
            get
            {
                return Itag;
            }
            set
            {
                Itag = value;Invalidate();
            }
        }*/

        // HalfCircle Properties
            private int _startangle = 0;
            private int _sweepangle = 180;
            private int _hcthick = 20;
            public int HCStartAngle   { get { return _startangle; }   set { _startangle = value; Invalidate(); } }
            public int HCSweepAngle   { get { return _sweepangle; }   set { _sweepangle = value; Invalidate(); } }
            public int HCThick      { get { return _hcthick; }   set { _hcthick = value; Invalidate(); } }
       

        #endregion
        #region EventHandler Methods
        /// <summary>
        ///  Mouse Event Handler methods 
        /// </summary>
        /// <param name="e"></param>
        protected override void OnMouseEnter(EventArgs e)
            {
                base.OnMouseEnter(e);
                InsideColorTemp = insideColor;
                BorderColorTemp = bordercolor;
                insideColor = m_hovercolor1;
                bordercolor = m_hovercolor2;
            }

            //method mouse leave  
            protected override void OnMouseLeave(EventArgs e)
            {
                base.OnMouseLeave(e);
                insideColor = InsideColorTemp;
                bordercolor = BorderColorTemp;
            }
            protected override void OnMouseUp(MouseEventArgs mevent)
            {
                base.OnMouseUp(mevent);
                insideColor = m_hovercolor1;
                bordercolor = m_hovercolor2;
                Invalidate();
            }
       
            //method mouse click  
            protected override void OnMouseClick(MouseEventArgs e)
            {
                if (e.Clicks == 1)
                {
                    base.OnMouseClick(e);
                    insideColor = clickcolor1;
                    bordercolor = clickcolor2;
                }
            }
            protected override void OnMouseDown(MouseEventArgs e)
            {
                if (e.Clicks == 1)
                {
                    base.OnMouseDown(e);
                    insideColor = clickcolor1;
                    bordercolor = clickcolor2;
                }
            }
            protected override void OnBackColorChanged(EventArgs e)
            {
                // Border Color Is the BackColor
                BorderColor = this.BackColor;
                int A, R, G, B;
                A = BorderColor.A + 100; if (A > 255) { A = 255; }
                R = BorderColor.R + 100; if (R > 255) { R = 255; }
                G = BorderColor.G + 100; if (G > 255) { G = 255; }
                B = BorderColor.B + 100; if (B > 255) { B = 255; }
                MouseHoverBorderColor = Color.FromArgb(A, R, G, B);

                A = BorderColor.A - 100; if (A < 9) { A = 9; }
                R = BorderColor.R - 100; if (R < 0) { R = 0; }
                G = BorderColor.G - 100; if (G < 0) { G = 0; }
                B = BorderColor.B - 100; if (B < 0) { B = 0; }
                MouseClickBorderColor = Color.FromArgb(A, R, G, B);
                color2Transparent = 255;

                base.OnBackColorChanged(e);
                Invalidate();
            }
            protected override void OnForeColorChanged(EventArgs e)
            {
                // Inside Color Is the ForeColor
                InsideColor = this.ForeColor;
                int A, R, G, B;
                A = InsideColor.A + 100; if (A > 255) { A = 255; }
                R = InsideColor.R + 100; if (R > 255) { R -= 100; }
                G = InsideColor.G + 100; if (G > 255) { G -= 100; }
                B = InsideColor.B + 100; if (B > 255) { B -= 100; }
                MouseHoverInsideColor = Color.FromArgb(A, R, G, B);

                A = InsideColor.A - 100; if (A < 9) { A = 9; }
                R = InsideColor.R - 100; if (R < 0) { R += 100; }
                G = InsideColor.G - 100; if (G < 0) { G += 100; }
                B = InsideColor.B - 100; if (B < 0) { B += 100; }
                MouseClickInsideColor = Color.FromArgb(A, R, G, B);
                color1Transparent = 255;

                base.OnForeColorChanged(e);
            }
            private void OnIsselectedChanged(EventArgs e)
            {
                Invalidate();
            }
        #endregion
        #region Button Drawing Methods
            private void Circle(PaintEventArgs pe)
            {
                SetStyle(ControlStyles.SupportsTransparentBackColor, true);
                SetStyle(ControlStyles.UserPaint, true);
            //Calculate Text Position In Circle
            text = this.Text;
                textX = ((this.Width / 2) - (text.Length * 2) - ((int)(this.Font.Size) / 2));
                textY = ((this.Height / 2) - ((int)(this.Font.Size)));

                Color c1 = Color.FromArgb(color1Transparent, insideColor);
                Color c2 = Color.FromArgb(color2Transparent, bordercolor);
                Color isSelectedColor = this.FlatAppearance.BorderColor;
                //Making Inside Gradient Color Base On ForeColor
                int A = c1.A - 10; if (A < 9) { A = 9; }
                int R = c1.R - 60; if (R < 0) { R = 0; }
                int G = c1.G - 60; if (G < 0) { G = 0; }
                int B = c1.B - 60; if (B < 0) { B = 0; }
                Color c1GradientColor = Color.FromArgb(A, R, G, B);

                //Making Border Gradient Color Base On BackColor
                A = c2.A - 10; if (A < 9) { A = 9; }
                R = c2.R - 60; if (R < 0) { R = 0; }
                G = c2.G - 60; if (G < 0) { G = 0; }
                B = c2.B - 60; if (B < 0) { B = 0; }
                Color c2GradientColor = Color.FromArgb(A, R, G, B);

                //Making Border Gradient Color Base On BackColor
                A = isSelectedColor.A - 10; if (A < 50) { A = 50; }
                R = isSelectedColor.R - 60; if (R < 0) { R = 0; }
                G = isSelectedColor.G - 60; if (G < 0) { G = 0; }
                B = isSelectedColor.B - 60; if (B < 0) { B = 0; }
                Color isSelectedColorGradientColor = Color.FromArgb(A, R, G, B);

                //Brush InsideBrush = new HatchBrush(HatchStyle.DottedGrid, c1);
                Brush InsideBrush = new LinearGradientBrush(ClientRectangle, c1, c1GradientColor, angle);
                Brush BorderBrush = new LinearGradientBrush(ClientRectangle, c2, c2GradientColor, -angle);
                Brush IsSelectedBrush = new LinearGradientBrush(ClientRectangle, isSelectedColor, isSelectedColorGradientColor, 180);

                Point p = new Point(textX, textY);
                SolidBrush frcolor = new SolidBrush(ITextColor);
                Border3DStyle borderStyle = Border3DStyle.SunkenInner;
                ControlPaint.DrawBorder3D(pe.Graphics, ClientRectangle, borderStyle);

                Graphics gfx = pe.Graphics;
                GraphicsPath grPath = new GraphicsPath();
                Pen Mypen = new Pen(Color.Black);
                //Pen ArcPen = new Pen(Color.Black, 5);
                Rectangle rc = ClientRectangle;
                rc.Width -= 1;
                rc.Height -= 1;

                if (isSelected == false)
                {
                    //this.FlatAppearance.BorderSize = 0;
                    gfx.FillEllipse(BorderBrush, new Rectangle(0, 0, rc.Width, rc.Height));
                    gfx.FillEllipse(InsideBrush, new Rectangle(borderThick, borderThick, rc.Width - (borderThick * 2), rc.Height - (borderThick * 2)));
                }
                else
                {
                    //this.FlatAppearance.BorderSize = 10;
                    //var bordersize = this.FlatAppearance.BorderSize;
                    gfx.FillEllipse(IsSelectedBrush, new Rectangle(0, 0, rc.Width, rc.Height));
                    gfx.FillEllipse(BorderBrush, new Rectangle(borderThick, borderThick, rc.Width - (borderThick * 2), rc.Height - (borderThick * 2)));
                    gfx.FillEllipse(InsideBrush, new Rectangle(borderThick * 2, borderThick * 2, rc.Width - (borderThick * 4), rc.Height - (borderThick * 4)));
                }
                gfx.DrawString(text, this.Font, frcolor, p);
                //Cut The Button To circle            
                grPath.AddEllipse(2, 2, ClientSize.Width - 4, ClientSize.Height - 4);
                this.Region = new System.Drawing.Region(grPath);
                BorderBrush.Dispose();
                InsideBrush.Dispose();
            }
            private void HalfCircle(PaintEventArgs pe)
            {
            //Calculate Text Position In Circle
            text = this.Text;
            textX = ((this.Width / 2) - (text.Length * 2) - ((int)(this.Font.Size) / 2));
            textY = ((this.Height / 2) - ((int)(this.Font.Size)));

            Color c1 = Color.FromArgb(color1Transparent, insideColor);
            Color c2 = Color.FromArgb(color2Transparent, bordercolor);
            Color isSelectedColor = this.FlatAppearance.BorderColor;
            //Making Inside Gradient Color Base On ForeColor
            int A = c1.A - 10; if (A < 9) { A = 9; }
            int R = c1.R - 60; if (R < 0) { R = 0; }
            int G = c1.G - 60; if (G < 0) { G = 0; }
            int B = c1.B - 60; if (B < 0) { B = 0; }
            Color c1GradientColor = Color.FromArgb(A, R, G, B);

            //Making Border Gradient Color Base On BackColor
            A = c2.A - 10; if (A < 9) { A = 9; }
            R = c2.R - 60; if (R < 0) { R = 0; }
            G = c2.G - 60; if (G < 0) { G = 0; }
            B = c2.B - 60; if (B < 0) { B = 0; }
            Color c2GradientColor = Color.FromArgb(A, R, G, B);

            //Making Border Gradient Color Base On BackColor
            A = isSelectedColor.A - 10; if (A < 50) { A = 50; }
            R = isSelectedColor.R - 60; if (R < 0) { R = 0; }
            G = isSelectedColor.G - 60; if (G < 0) { G = 0; }
            B = isSelectedColor.B - 60; if (B < 0) { B = 0; }
            Color isSelectedColorGradientColor = Color.FromArgb(A, R, G, B);

            //Brush InsideBrush = new HatchBrush(HatchStyle.DottedGrid, c1);
            Brush InsideBrush = new LinearGradientBrush(ClientRectangle, c1, c1GradientColor, angle);
            Brush BorderBrush = new LinearGradientBrush(ClientRectangle, c2, c2GradientColor, -angle);
            Brush IsSelectedBrush = new LinearGradientBrush(ClientRectangle, isSelectedColor, isSelectedColorGradientColor, 180);

            Point p = new Point(textX, textY);
            SolidBrush frcolor = new SolidBrush(ITextColor);
            Border3DStyle borderStyle = Border3DStyle.SunkenInner;
            ControlPaint.DrawBorder3D(pe.Graphics, ClientRectangle, borderStyle);

            Graphics gfx = pe.Graphics;
            GraphicsPath grPath = new GraphicsPath();
            Pen Mypen = new Pen(Color.Black);
            //Pen ArcPen = new Pen(Color.Black, 5);
            Rectangle rc = ClientRectangle;
            rc.Width -= 1;
            rc.Height -= 1;

            if (isSelected == false)
            {
                //this.FlatAppearance.BorderSize = 0;
                gfx.FillEllipse(BorderBrush, new Rectangle(0, 0, rc.Width, rc.Height));
                gfx.FillEllipse(InsideBrush, new Rectangle(borderThick, borderThick, rc.Width - (borderThick * 2), rc.Height - (borderThick * 2)));
            }
            else
            {
                //this.FlatAppearance.BorderSize = 10;
                //var bordersize = this.FlatAppearance.BorderSize;
                gfx.FillEllipse(IsSelectedBrush, new Rectangle(0, 0, rc.Width, rc.Height));
                gfx.FillEllipse(BorderBrush, new Rectangle(borderThick, borderThick, rc.Width - (borderThick * 2), rc.Height - (borderThick * 2)));
                gfx.FillEllipse(InsideBrush, new Rectangle(borderThick * 2, borderThick * 2, rc.Width - (borderThick * 4), rc.Height - (borderThick * 4)));
            }
            try
            { 
                gfx.DrawString(text, this.Font, frcolor, p);
                //Cut The Button To Half circle            
                grPath.AddArc(new Rectangle(2,2, ClientSize.Width -4, ClientSize.Height-4), _startangle, _sweepangle);
                grPath.AddArc(new Rectangle(_hcthick, _hcthick, ClientSize.Width - (_hcthick*2), ClientSize.Height- (_hcthick*2)), _startangle, _sweepangle);
                this.Region = new System.Drawing.Region(grPath);
            }
            catch { }
            BorderBrush.Dispose();
            InsideBrush.Dispose();
        }
            private void Rectanlge(PaintEventArgs pe)
            {
                //Calculate Text Position In Circle
                text = this.Text;
                textX = ((this.Width / 2) - (text.Length * 2) - ((int)(this.Font.Size) / 2));
                textY = ((this.Height / 2) - ((int)(this.Font.Size)));

                Color c1 = Color.FromArgb(color1Transparent, insideColor);
                Color c2 = Color.FromArgb(color2Transparent, bordercolor);
                Color isSelectedColor = this.FlatAppearance.BorderColor;
                //Making Inside Gradient Color Base On ForeColor
                int A = c1.A - 10; if (A < 9) { A = 9; }
                int R = c1.R - 60; if (R < 0) { R = 0; }
                int G = c1.G - 60; if (G < 0) { G = 0; }
                int B = c1.B - 60; if (B < 0) { B = 0; }
                Color c1GradientColor = Color.FromArgb(A, R, G, B);

                //Making Border Gradient Color Base On BackColor
                A = c2.A - 10; if (A < 9) { A = 9; }
                R = c2.R - 60; if (R < 0) { R = 0; }
                G = c2.G - 60; if (G < 0) { G = 0; }
                B = c2.B - 60; if (B < 0) { B = 0; }
                Color c2GradientColor = Color.FromArgb(A, R, G, B);

                //Making Border Gradient Color Base On BackColor
                A = isSelectedColor.A - 10; if (A < 50) { A = 50; }
                R = isSelectedColor.R - 60; if (R < 0) { R = 0; }
                G = isSelectedColor.G - 60; if (G < 0) { G = 0; }
                B = isSelectedColor.B - 60; if (B < 0) { B = 0; }
                Color isSelectedColorGradientColor = Color.FromArgb(A, R, G, B);

                //Brush InsideBrush = new HatchBrush(HatchStyle.DottedGrid, c1);
                Brush InsideBrush = new LinearGradientBrush(ClientRectangle, c1, c1GradientColor, angle);
                Brush BorderBrush = new LinearGradientBrush(ClientRectangle, c2, c2GradientColor, -angle);
                Brush IsSelectedBrush = new LinearGradientBrush(ClientRectangle, isSelectedColor, isSelectedColorGradientColor, 180);

                Point p = new Point(textX, textY);
                SolidBrush frcolor = new SolidBrush(ITextColor);
                Border3DStyle borderStyle = Border3DStyle.SunkenInner;
                ControlPaint.DrawBorder3D(pe.Graphics, ClientRectangle, borderStyle);

                Graphics gfx = pe.Graphics;
                GraphicsPath grPath = new GraphicsPath();
                Pen Mypen = new Pen(Color.Black);
                //Pen ArcPen = new Pen(Color.Black, 5);
                Rectangle rc = ClientRectangle;
                rc.Width -= 1;
                rc.Height -= 1;
                if (isSelected == false)
                {
                    //this.FlatAppearance.BorderSize = 0;
                    gfx.FillRectangle(BorderBrush, new Rectangle(0, 0, rc.Width, rc.Height));
                    gfx.FillRectangle(InsideBrush, new Rectangle(borderThick, borderThick, rc.Width - (borderThick * 2), rc.Height - (borderThick * 2)));
                }
                else
                {
                    //this.FlatAppearance.BorderSize = 10;
                    //var bordersize = this.FlatAppearance.BorderSize;
                    gfx.FillRectangle(IsSelectedBrush, new Rectangle(0, 0, rc.Width, rc.Height));
                    gfx.FillRectangle(BorderBrush, new Rectangle(borderThick, borderThick, rc.Width - (borderThick * 2), rc.Height - (borderThick * 2)));
                    gfx.FillRectangle(InsideBrush, new Rectangle(borderThick * 2, borderThick * 2, rc.Width - (borderThick * 4), rc.Height - (borderThick * 4)));
                }
                gfx.DrawString(text, this.Font, frcolor, p);
                //Cut The Button To circle            
                grPath.AddRectangle(new Rectangle (2, 2, ClientSize.Width - 4, ClientSize.Height - 4));
                this.Region = new System.Drawing.Region(grPath);
                BorderBrush.Dispose();
                InsideBrush.Dispose();
            }
            private void Curve(PaintEventArgs pe)
            {
                //Calculate Text Position In Circle
                text = this.Text;
                textX = ((this.Width / 2) - (text.Length * 2) - ((int)(this.Font.Size) / 2));
                textY = ((this.Height / 2) - ((int)(this.Font.Size)));

                Color c1 = Color.FromArgb(color1Transparent, insideColor);
                Color c2 = Color.FromArgb(color2Transparent, bordercolor);
                Color isSelectedColor = this.FlatAppearance.BorderColor;
                //Making Inside Gradient Color Base On ForeColor
                int A = c1.A - 10; if (A < 9) { A = 9; }
                int R = c1.R - 60; if (R < 0) { R = 0; }
                int G = c1.G - 60; if (G < 0) { G = 0; }
                int B = c1.B - 60; if (B < 0) { B = 0; }
                Color c1GradientColor = Color.FromArgb(A, R, G, B);

                //Making Border Gradient Color Base On BackColor
                A = c2.A - 10; if (A < 9) { A = 9; }
                R = c2.R - 60; if (R < 0) { R = 0; }
                G = c2.G - 60; if (G < 0) { G = 0; }
                B = c2.B - 60; if (B < 0) { B = 0; }
                Color c2GradientColor = Color.FromArgb(A, R, G, B);

                //Making Border Gradient Color Base On BackColor
                A = isSelectedColor.A - 10; if (A < 50) { A = 50; }
                R = isSelectedColor.R - 60; if (R < 0) { R = 0; }
                G = isSelectedColor.G - 60; if (G < 0) { G = 0; }
                B = isSelectedColor.B - 60; if (B < 0) { B = 0; }
                Color isSelectedColorGradientColor = Color.FromArgb(A, R, G, B);

                //Brush InsideBrush = new HatchBrush(HatchStyle.DottedGrid, c1);
                Brush InsideBrush = new LinearGradientBrush(ClientRectangle, c1, c1GradientColor, angle);            
                Brush BorderBrush = new LinearGradientBrush(ClientRectangle, c2, c2GradientColor, -angle);
                Pen BorderPen = new Pen(c2, borderThick);
                Brush IsSelectedBrush = new LinearGradientBrush(ClientRectangle, isSelectedColor, isSelectedColorGradientColor, 180);
                Pen IsSelectedPen = new Pen(isSelectedColor, borderThick*2);

                Point p = new Point(textX, textY);
                SolidBrush frcolor = new SolidBrush(ITextColor);
                Border3DStyle borderStyle = Border3DStyle.SunkenInner;
                ControlPaint.DrawBorder3D(pe.Graphics, ClientRectangle, borderStyle);

                Graphics gfx = pe.Graphics;
                gfx.SmoothingMode = SmoothingMode.HighQuality;
                gfx.InterpolationMode = InterpolationMode.HighQualityBilinear;
                gfx.CompositingQuality = CompositingQuality.HighQuality;
                gfx.PixelOffsetMode = PixelOffsetMode.HighQuality;
                GraphicsPath grPath = new GraphicsPath();
            
                Pen Mypen = new Pen(Color.Black);

                Rectangle rc = ClientRectangle;
                var margin = 5.0F;
                margin = ((ClientSize.Width +ClientSize.Height)/2)/10  ;

                var WidthStart = margin ;
                var HeightStart = margin ;
                var WidthEnd = rc.Width - margin ;
                var HeightEnd = rc.Height - margin;
                PointF point1 = new PointF(WidthStart, HeightStart);
                PointF point2 = new PointF(WidthEnd, HeightStart);
                PointF point3 = new PointF(WidthEnd, HeightEnd);
                PointF point4 = new PointF(WidthStart, HeightEnd);
                PointF[] curvePoints = { point1, point2, point3, point4 };

                float tension = 0.20F;
                FillMode aFillMode = FillMode.Alternate;

                if (isSelected == false)
                {
                    //this.FlatAppearance.BorderSize = 0;
                    //Fill Inside
                    gfx.FillClosedCurve(InsideBrush, curvePoints);
                    //Draw Border
                    gfx.DrawClosedCurve(BorderPen, curvePoints, tension, aFillMode);
                }
                else
                {
                    //Fill Inside Area
                    gfx.FillClosedCurve(InsideBrush, curvePoints);

                    WidthStart = margin + borderThick;
                    HeightStart = margin + borderThick ;
                    WidthEnd = rc.Width - margin - borderThick  ;
                    HeightEnd = rc.Height - margin - borderThick ;
                    point1 = new PointF(WidthStart, HeightStart);
                    point2 = new PointF(WidthEnd, HeightStart);
                    point3 = new PointF(WidthEnd, HeightEnd);
                    point4 = new PointF(WidthStart, HeightEnd);
                    PointF[] curvePointsInsideB = new PointF[] { point1, point2, point3, point4 };
                    //Draw Border Area
                    gfx.DrawClosedCurve(BorderPen, curvePointsInsideB, tension, aFillMode);

                    //DrawSelected Area With this.FlatAppearance.BorderColor
                    gfx.DrawClosedCurve(IsSelectedPen, curvePoints, tension, aFillMode);

                }
                gfx.DrawString(text, this.Font, frcolor, p);
                //Cut The Button To Curve Points   
                grPath.AddClosedCurve(curvePoints, tension);
                this.Region = new System.Drawing.Region(grPath);

                BorderBrush.Dispose();
                InsideBrush.Dispose();
            }
            private void RoundRectanlge(PaintEventArgs pe)
            {
                //Calculate Text Position In Circle
                text = this.Text;
                textX = ((this.Width / 2) - (text.Length * 2) - ((int)(this.Font.Size) / 2));
                textY = ((this.Height / 2) - ((int)(this.Font.Size)));

                Color c1 = Color.FromArgb(color1Transparent, insideColor);
                Color c2 = Color.FromArgb(color2Transparent, bordercolor);
                Color isSelectedColor = this.FlatAppearance.BorderColor;
                //Making Inside Gradient Color Base On ForeColor
                int A = c1.A - 10; if (A < 9) { A = 9; }
                int R = c1.R - 60; if (R < 0) { R = 0; }
                int G = c1.G - 60; if (G < 0) { G = 0; }
                int B = c1.B - 60; if (B < 0) { B = 0; }
                Color c1GradientColor = Color.FromArgb(A, R, G, B);

                //Making Border Gradient Color Base On BackColor
                A = c2.A - 10; if (A < 9) { A = 9; }
                R = c2.R - 60; if (R < 0) { R = 0; }
                G = c2.G - 60; if (G < 0) { G = 0; }
                B = c2.B - 60; if (B < 0) { B = 0; }
                Color c2GradientColor = Color.FromArgb(A, R, G, B);

                //Making Border Gradient Color Base On BackColor
                A = isSelectedColor.A - 10; if (A < 50) { A = 50; }
                R = isSelectedColor.R - 60; if (R < 0) { R = 0; }
                G = isSelectedColor.G - 60; if (G < 0) { G = 0; }
                B = isSelectedColor.B - 60; if (B < 0) { B = 0; }
                Color isSelectedColorGradientColor = Color.FromArgb(A, R, G, B);

                //Brush InsideBrush = new HatchBrush(HatchStyle.DottedGrid, c1);
                Brush InsideBrush = new LinearGradientBrush(ClientRectangle, c1, c1GradientColor, angle);
                Pen InsidePen = new Pen(c1, borderThick);
                Brush BorderBrush = new LinearGradientBrush(ClientRectangle, c2, c2GradientColor, -angle);
                Pen BorderPen = new Pen(c2, borderThick);
                Brush IsSelectedBrush = new LinearGradientBrush(ClientRectangle, isSelectedColor, isSelectedColorGradientColor, 180);
                Pen IsSelectedPen = new Pen(isSelectedColor, borderThick);

                Point p = new Point(textX, textY);
                SolidBrush frcolor = new SolidBrush(ITextColor);
                Border3DStyle borderStyle = Border3DStyle.SunkenInner;
                ControlPaint.DrawBorder3D(pe.Graphics, ClientRectangle, borderStyle);

                Graphics gfx = pe.Graphics;
                GraphicsPath grPath = new GraphicsPath();
                Pen Mypen = new Pen(Color.Black);

                Rectangle rc = ClientRectangle;
                int margin = 5;
                //margin = ((ClientSize.Width + ClientSize.Height) / 2) / 10;

                int WidthStart = margin;
                int HeightStart = margin;
                int WidthEnd = rc.Width - margin;
                int HeightEnd = rc.Height - margin;
                //float tension = 0.20F;
                //FillMode aFillMode = FillMode.Alternate;
            

                if (isSelected == false)
                {
                 //Fill Inside
                    gfx.FillRoundedRectangle(InsideBrush, new Rectangle(WidthStart, HeightStart, WidthEnd, HeightEnd), radiusRoundRect);
                 //Draw Border
                    gfx.DrawRoundedRectangle(BorderPen, new Rectangle(WidthStart, HeightStart, WidthEnd, HeightEnd), radiusRoundRect);
                }
                else
                {
                
                    //var bordersize = this.FlatAppearance.BorderSize;

                    //Fill Inside Area
                    gfx.FillRoundedRectangle(InsideBrush, new Rectangle(WidthStart, HeightStart, WidthEnd, HeightEnd), radiusRoundRect);

                    //Border3DSide Values
                    var WidthStartB = margin*2 + borderThick/4;
                    var HeightStartB = margin*2 + borderThick/4;
                    var WidthEndB = rc.Width - margin*3 - borderThick/2;
                    var HeightEndB = rc.Height - margin*3 - borderThick/2;
                    //Draw Border Area
                    gfx.DrawRoundedRectangle(BorderPen, new Rectangle(WidthStartB, HeightStartB, WidthEndB, HeightEndB), radiusRoundRect);
                    //DrawSelected Area With this.FlatAppearance.BorderColor
                    gfx.DrawRoundedRectangle(IsSelectedPen, new Rectangle(WidthStart, HeightStart, WidthEnd, HeightEnd), radiusRoundRect);
                
                }
                gfx.DrawString(text, this.Font, frcolor, p);
                //Cut The Button To Curve Points   

                RectangleEdgeFilter REF = RectangleEdgeFilter.All;
                var Roundpath = gfx.GenerateRoundedRectangle(new RectangleF(((float)(WidthStart)), HeightStart, WidthEnd, HeightEnd), radiusRoundRect, REF);
                grPath = Roundpath;
                this.Region = new System.Drawing.Region(grPath);

                BorderBrush.Dispose();
                InsideBrush.Dispose();
            }
        #endregion
        protected override void OnPaint(PaintEventArgs pe)
        {
            base.OnPaint(pe);
            
            switch (buttonTypeE)
            {
                case ButtonTypeEnum.CircleButton: { Circle(pe); break; }
                case ButtonTypeEnum.CurveButton: { Curve(pe); break; }
                case ButtonTypeEnum.HalfCircleButton: { HalfCircle(pe); break; }
                case ButtonTypeEnum.RectanlgeButton: { Rectanlge(pe); break; }
                case ButtonTypeEnum.RoundRectanlgeButton: { RoundRectanlge(pe); break; }
                default: break;
            }
        }
        #region Hide Properties
        private string[] propertyNames = new string[] {};
        public object GetWrapper
        {
            get
            {
                if (buttonTypeE == ButtonTypeEnum.RoundRectanlgeButton)
                {
                    propertyNames = new string[]
                    {"Radius","ISizeWidth","ISizeHeight","PositionX","PositionY", "ButtonType","BorderThick","GradientAngle","IBorderColors","IInsideColors","ITextColor","ISelectedColor","IText","IMaxScript" };
                    object SelectedObject = ObjectWrapperFactory.CreateWrapperWithVisibleProperties(this, propertyNames).Wrapper;
                    Invalidate();
                    return SelectedObject;

                } else if (buttonTypeE == ButtonTypeEnum.HalfCircleButton)
                {
                    propertyNames = new string[]
                    {"Radius","ISizeWidth","ISizeHeight","PositionX","PositionY", "ButtonType","BorderThick","GradientAngle","IBorderColors","IInsideColors","ITextColor","ISelectedColor","IText","HCStartAngle","HCSweepAngle","HCThick","IMaxScript" };
                    object SelectedObject = ObjectWrapperFactory.CreateWrapperWithVisibleProperties(this, propertyNames).Wrapper;
                    Invalidate();
                    return SelectedObject;

                }
                else
                {
                    propertyNames = new string[]
                    {"ISizeWidth","ISizeHeight","PositionX","PositionY", "ButtonType","BorderThick","GradientAngle","IBorderColors","IInsideColors","ITextColor","ISelectedColor","IText","IMaxScript" };
                    object SelectedObject = ObjectWrapperFactory.CreateWrapperWithVisibleProperties(this, propertyNames).Wrapper;
                    Invalidate();
                    return SelectedObject;
                }
            }

        }
        #endregion
    }


}

