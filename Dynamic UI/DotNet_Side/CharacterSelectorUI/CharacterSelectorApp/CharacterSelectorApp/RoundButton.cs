using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace CharacterSelectorApp
{
    public partial class RoundButton : Button
    {
#region private Values
        Color clr1, clr2;
        private Color color1 = Color.Black;
        private Color color2 = Color.Yellow;
        private Color m_hovercolor1 = Color.DarkOrange;
        private Color m_hovercolor2 = Color.DarkOrange;
        private int color1Transparent = 150;
        private int color2Transparent = 150;
        private Color clickcolor1 = Color.White;
        private Color clickcolor2 = Color.Black;
        private int angle = 90;
        private int textX = 100;
        private int textY = 25;
        private int borderThick = 5;
        private String text = "";
        public String ClassName = "RoundButton";
        #endregion
        #region Public Properties
        //Create Properties to read Button Text,Colors etc  

        public String DisplayText
        {
            get { return text; }
            set { text = value; Invalidate(); }
        }

        public Color InsideColor
        {
            get { return color1; }
            set { color1 = value; Invalidate(); }
        }

        public Color BorderColor
        {
            get { return color2; }
            set { color2 = value; Invalidate(); }
        }

        public Color MouseHoverColor1
        {
            get { return m_hovercolor1; }
            set { m_hovercolor1 = value; Invalidate(); }
        }

        public Color MouseHoverColor2
        {
            get { return m_hovercolor2; }
            set { m_hovercolor2 = value; Invalidate(); }
        }

        public Color MouseClickColor1
        {
            get { return clickcolor1; }
            set { clickcolor1 = value; Invalidate(); }
        }

        public Color MouseClickColor2
        {
            get { return clickcolor2; }
            set { clickcolor2 = value; Invalidate(); }
        }

        public int Transparent1
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

        public int Transparent2
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

        public int GradientAngle
        {
            get { return angle; }
            set { angle = value; Invalidate(); }
        }

        public int TextLocation_X
        {
            get { return textX; }
            set { textX = value; Invalidate(); }
        }

        public int TextLocation_Y
        {
            get { return textY; }
            set { textY = value; Invalidate(); }
        }

        public int BorderThick
        {
            get { return borderThick; }
            set { borderThick = value; }
        }

        public RoundButton()
        {
            this.Size = new System.Drawing.Size(200, 50);
            this.ForeColor = Color.White;
            this.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            text = this.Text;
        }
#endregion
#region EventHandler Methods
        //method mouse enter  
        protected override void OnMouseEnter(EventArgs e)
        {
            base.OnMouseEnter(e);
            clr1 = color1;
            clr2 = color2;
            color1 = m_hovercolor1;
            color2 = m_hovercolor2;
        }

        //method mouse leave  
        protected override void OnMouseLeave(EventArgs e)
        {
            base.OnMouseLeave(e);
            color1 = clr1;
            color2 = clr2;
        }

        //method mouse click  
        protected override void OnMouseClick(MouseEventArgs e)
        {
            if (e.Clicks == 1)
            {
                base.OnMouseClick(e);
                color1 = clickcolor1;
                color2 = clickcolor2;
            }
        }
        protected override void OnMouseDown(MouseEventArgs e)
        {
            if (e.Clicks == 1)
            {
                base.OnMouseDown(e);
                color1 = clickcolor1;
                color2 = clickcolor2;
            }
        }
#endregion        
        protected override void OnPaint(PaintEventArgs pe)
        {
            base.OnPaint(pe);
            text = this.Text;
            
            //if (textX == 100 && textY == 25)
            //{
            textX = ((this.Width/2)-(text.Length*2)-((int)(this.Font.Size)/2));
            textY = ((this.Height/2)-((int)(this.Font.Size)));
            //}

            Color c1 = Color.FromArgb(color1Transparent, color1);
            Color c2 = Color.FromArgb(color2Transparent, color2);
            //drawing string & filling gradient rectangle   
            //Brush brushBorder = new System.Drawing.Drawing2D.LinearGradientBrush(ClientRectangle, c1, c2, angle);
            //Brush BrushInside = new System.Drawing.Drawing2D.LinearGradientBrush(ClientRectangle, c2, c1, angle);
            Brush brushBorder = new System.Drawing.Drawing2D.LinearGradientBrush(ClientRectangle, c1, c1, angle);
            Brush BrushInside = new System.Drawing.Drawing2D.LinearGradientBrush(ClientRectangle, c2, c2, angle);
            Point p = new Point(textX, textY);
            SolidBrush frcolor = new SolidBrush(this.ForeColor);
            //Brush b = new System.Drawing.Drawing2D.LinearGradientBrush(ClientRectangle, c1, c2, angle);

            //pe.Graphics.FillRectangle(b, ClientRectangle);
            //pe.Graphics.DrawString(text, this.Font, frcolor, p);
            Border3DStyle borderStyle = Border3DStyle.SunkenInner;
            ControlPaint.DrawBorder3D(pe.Graphics, ClientRectangle, borderStyle);

            Graphics gfx = pe.Graphics;
            Pen Mypen = new Pen(Color.Black);
            Rectangle rc = ClientRectangle;
            rc.Width -= 1;
            rc.Height -= 1;
            gfx.FillEllipse(brushBorder, new Rectangle(0, 0, rc.Width, rc.Height));
            gfx.FillEllipse(BrushInside, new Rectangle(borderThick, borderThick, rc.Width - (borderThick*2), rc.Height - (borderThick * 2)));
            gfx.DrawString(text, this.Font, frcolor, p);

            //Cut The Button To circle            
            GraphicsPath grPath = new GraphicsPath();
            grPath.AddEllipse(0, 0, ClientSize.Width, ClientSize.Height);
            this.Region = new System.Drawing.Region(grPath);

            brushBorder.Dispose();
            BrushInside.Dispose();
        }
    }
}
