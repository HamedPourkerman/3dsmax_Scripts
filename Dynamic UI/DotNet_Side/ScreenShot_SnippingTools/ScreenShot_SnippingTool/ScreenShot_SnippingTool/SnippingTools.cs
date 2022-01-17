using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ScreenShot_SnippingTool
{
    class SnippingTools
    {
        public SnippingTools()
        {

        }
        public void CaptureScreen (Control control )
            {
                Bitmap bitmap = new Bitmap(Screen.PrimaryScreen.Bounds.Width, Screen.PrimaryScreen.Bounds.Height);
                Graphics graphic = Graphics.FromImage(bitmap as Image);
                graphic.CopyFromScreen(0, 0, 0, 0, bitmap.Size);

            // if Control is PictureBox 
            try {
                    var PicBox = (PictureBox)(control);
                    PicBox.SizeMode = PictureBoxSizeMode.StretchImage;
                    PicBox.Image = bitmap;
            }
            catch (Exception e)
            { MessageBox.Show(e.Message); }
            // if Control is Panel
            try
            {
                var PanelContainer = (Panel)(control);
                //PanelContainer.SizeMode = PictureBoxSizeMode.StretchImage;
                PanelContainer.BackgroundImage = bitmap;
                
            }
            catch (Exception e)
            { MessageBox.Show(e.Message); }

        }
    }
}
