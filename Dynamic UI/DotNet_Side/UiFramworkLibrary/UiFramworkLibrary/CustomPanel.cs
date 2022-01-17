using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace UiFramworkLibrary
{
    public partial class CustomPanel : Panel
    {
        #region Constructor
        public CustomPanel()
        {
            this.SetStyle(
                System.Windows.Forms.ControlStyles.UserPaint |
                System.Windows.Forms.ControlStyles.AllPaintingInWmPaint |
                System.Windows.Forms.ControlStyles.OptimizedDoubleBuffer,
                true);
            this.picture = this.BackgroundImage; 
            this.BackgroundImageTemp = this.BackgroundImage; 
        }
        #endregion
        #region Private & Publics
            private List<Button> _selected = new List<Button>();
            private Image picture;
            private Image BackgroundImageTemp;
            private Point pictureLocation;
            private int locationX = 0;
            private int locationY = 0;
            private int iwidth = 800;
            private int iheight = 600;
            
            public Button[] SelectedButtons
        {
            get
            {
                Button[] BtnArray = _selected.ToArray();
                return BtnArray;
                
            }
            set
            {
                Button[] BtnArray = _selected.ToArray();
                List<Button> BtnList =  value.ToList();
                _selected = BtnList;
                Invalidate();
            }
        }
            public int PositionX
            {
                get { return locationX; }
                set { locationX = value; Invalidate(); }
            }
            public int PositionY
            {
                get { return locationY; }
                set { locationY = value; Invalidate(); }
            }
            public int Iwidth
            {
                get { return iwidth; }
                set { iwidth = value; Invalidate(); }
            }
            public int Iheight
            {
                get { return iheight; }
                set { iheight = value; Invalidate(); }
            }
            public int ImageWidth
            {
                get
                {
                    if (this.BackgroundImage != null)
                    {
                        return (int)(this.BackgroundImage.PhysicalDimension.Width);
                }
                    else
                    {
                        return 800;
                    }
                }
            }
            public int ImageHeight {
            get
            {
                if (this.BackgroundImage != null)
                {
                    return (int)(this.BackgroundImage.PhysicalDimension.Height);
                }
                else
                {
                    return 800;
                } 
            }
        }
            public object GetWrapper
            {
                get
                {
                    var propertyNames = new string[]
                    {"PositionX", "PositionY","Iwidth", "Iheight"};
                    object SelectedObject = ObjectWrapperFactory.CreateWrapperWithVisibleProperties(this, propertyNames).Wrapper;
                    Invalidate();
                    return SelectedObject;
                }
            }
        #endregion
        #region Rectangle Selection
        private Point selectionStart;
            private Point selectionEnd;
            internal Rectangle selection;
            internal bool mouseDown;
            private void GetSelectedButtons()
            {
                foreach (Control c in Controls)
                {
                    if ((c is Button))
                    {
                        if (selection.IntersectsWith(c.Bounds))
                        {
                            _selected.Add((Button)c);
                        }
                    }
                }
            }
            protected override void OnMouseDown(MouseEventArgs e)
            {
                _selected.Clear();
                selectionStart = PointToClient(MousePosition);
                mouseDown = true;
                base.OnMouseDown(e);
            }
            protected override void OnMouseUp(MouseEventArgs e)
            {
                mouseDown = false;
                SetSelectionRect();
                Invalidate();
                GetSelectedButtons();
                base.OnMouseUp(e);
                Invalidate();

            }
            protected override void OnMouseMove(MouseEventArgs e)
            {
                if (!mouseDown)
                {
                    return;
                }

                selectionEnd = PointToClient(MousePosition);
                SetSelectionRect();
                base.OnMouseMove(e);
                Invalidate();
            }
            protected override void OnPaint(PaintEventArgs e)
            {
                base.OnPaint(e);
                this.picture = this.BackgroundImage;
                this.pictureLocation = new Point(PositionX, PositionY);
                Pen Mypen = new Pen(this.BackColor, 1);
                if (this.picture != null && this.pictureLocation != Point.Empty)
                {
                    //this.BackgroundImage = null;
                    //e.Graphics.DrawRectangle(Mypen, (new Rectangle(0, 0, this.Width, this.Height)));
                    e.Graphics.Clear(this.BackColor);
                    //e.Graphics.DrawImage(this.picture, this.pictureLocation);
                    e.Graphics.DrawImage(this.picture, PositionX, PositionY, Iwidth, Iheight);
                    //this.BackgroundImage = this.picture;
                }
                if (mouseDown)
                {
                    using (Pen pen = new Pen(Color.White, 1F))
                    {
                        Color brushcolor = Color.FromArgb(20, 0, 255, 0);
                        Brush brush = new SolidBrush(brushcolor);
                        e.Graphics.FillRectangle(brush, selection);
                        
                        pen.DashStyle = DashStyle.Dash;
                        e.Graphics.DrawRectangle(pen, selection);
                        brush.Dispose();
                    }
                }

            }
            private void SetSelectionRect()
            {
                int x, y;
                int width, height;

                x = selectionStart.X > selectionEnd.X ? selectionEnd.X : selectionStart.X;
                y = selectionStart.Y > selectionEnd.Y ? selectionEnd.Y : selectionStart.Y;

                width = selectionStart.X > selectionEnd.X ? selectionStart.X - selectionEnd.X : selectionEnd.X - selectionStart.X;
                height = selectionStart.Y > selectionEnd.Y ? selectionStart.Y - selectionEnd.Y : selectionEnd.Y - selectionStart.Y;

                selection = new Rectangle(x, y, width, height);
            }
        #endregion
        
    }
}

