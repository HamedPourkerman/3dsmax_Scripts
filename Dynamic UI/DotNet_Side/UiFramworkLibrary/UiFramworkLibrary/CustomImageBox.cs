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

namespace UiFramworkLibrary
{
    public partial class CustomImageBox : PictureBox 
    {
        public CustomImageBox()
        {
            this.Image = new Bitmap(800, 600);
            this.Size = new Size(800, 600);
            this.Location = new Point(0, 0);
            this.SizeMode = PictureBoxSizeMode.Zoom;
            
        }
        public int ImageSizeX
        {
            get { return this.Size.Width; }
            set { this.Size = new Size(value, this.Size.Height); Invalidate(); }
        }
        public int ImageSizeY
        {
            get { return this.Size.Height; }
            set { this.Size = new Size(this.Size.Width, value); Invalidate(); }
        }
        public int LocationX
        {
            get { return this.Location.X; }
            set { this.Location = new Point(value, this.Location.Y); Invalidate(); }
        }
        public int LocationY
        {
            get { return this.Location.Y; }
            set { this.Location = new Point(this.Location.X, value); Invalidate(); }
        }
        public Image Picture
        {
            get { return this.Image; }
            set { this.Image = value; Invalidate(); }
        }
        public object GetWrapper
        {
            get
            {
                var propertyNames = new string[]
                {"ImageSizeX", "ImageSizeY","LocationX", "LocationY"};
                object SelectedObject = ObjectWrapperFactory.CreateWrapperWithVisibleProperties(this, propertyNames).Wrapper;
                Invalidate();
                return SelectedObject;
            }

        }

        protected override void OnMouseClick(MouseEventArgs e)
        {

        }
        protected override void OnMouseDown(MouseEventArgs e)
        {
        }
        protected override void OnMouseUp(MouseEventArgs e)
        {
        }
        protected override void OnMouseEnter(EventArgs e)
        {
        }
        protected override void OnMouseMove(MouseEventArgs e)
        {
        }
        protected override void OnPaint(PaintEventArgs e)
        {
            base.OnPaint(e);
        }
    }
}
