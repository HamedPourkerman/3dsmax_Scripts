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
using UiFramworkLibrary;

namespace CharacterSelectorApp
{
    public partial class Form1 : Form
    {
       //bool toggle = false;
       public Form1()
        {
            InitializeComponent();
            this.Focus();
        }

        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.propertyGrid1 = new System.Windows.Forms.PropertyGrid();
            this.menuStrip1 = new System.Windows.Forms.MenuStrip();
            this.alignToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.centerToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.mirrorXToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.mirrorYToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.mirrorYToolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
            this.mirrorYLeftToRightToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.pictureBox1 = new System.Windows.Forms.PictureBox();
            this.graphicButton1 = new UiFramworkLibrary.GraphicButton();
            this.customPanel1 = new UiFramworkLibrary.CustomPanel();
            this.tabControl1 = new System.Windows.Forms.TabControl();
            this.tabPage1 = new System.Windows.Forms.TabPage();
            this.graphicButton2 = new UiFramworkLibrary.GraphicButton();
            this.tabPage2 = new System.Windows.Forms.TabPage();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.button1 = new System.Windows.Forms.Button();
            this.customPropertyGrid1 = new UiFramworkLibrary.CustomPropertyGrid();
            this.graphicButton3 = new UiFramworkLibrary.GraphicButton();
            this.contextMenuStrip1 = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.toolTip1 = new System.Windows.Forms.ToolTip(this.components);
            this.menuStrip1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
            this.customPanel1.SuspendLayout();
            this.tabControl1.SuspendLayout();
            this.tabPage1.SuspendLayout();
            this.SuspendLayout();
            // 
            // propertyGrid1
            // 
            this.propertyGrid1.Dock = System.Windows.Forms.DockStyle.Right;
            this.propertyGrid1.Location = new System.Drawing.Point(798, 24);
            this.propertyGrid1.Name = "propertyGrid1";
            this.propertyGrid1.Size = new System.Drawing.Size(279, 669);
            this.propertyGrid1.TabIndex = 0;
            // 
            // menuStrip1
            // 
            this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.alignToolStripMenuItem});
            this.menuStrip1.Location = new System.Drawing.Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new System.Drawing.Size(1077, 24);
            this.menuStrip1.TabIndex = 4;
            this.menuStrip1.Text = "menuStrip1";
            // 
            // alignToolStripMenuItem
            // 
            this.alignToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.centerToolStripMenuItem,
            this.mirrorXToolStripMenuItem,
            this.mirrorYToolStripMenuItem,
            this.mirrorYToolStripMenuItem1,
            this.mirrorYLeftToRightToolStripMenuItem});
            this.alignToolStripMenuItem.Name = "alignToolStripMenuItem";
            this.alignToolStripMenuItem.Size = new System.Drawing.Size(47, 20);
            this.alignToolStripMenuItem.Text = "Align";
            // 
            // centerToolStripMenuItem
            // 
            this.centerToolStripMenuItem.Name = "centerToolStripMenuItem";
            this.centerToolStripMenuItem.Size = new System.Drawing.Size(188, 22);
            this.centerToolStripMenuItem.Text = "Center";
            // 
            // mirrorXToolStripMenuItem
            // 
            this.mirrorXToolStripMenuItem.Name = "mirrorXToolStripMenuItem";
            this.mirrorXToolStripMenuItem.Size = new System.Drawing.Size(188, 22);
            this.mirrorXToolStripMenuItem.Text = "MirrorX Left To Right";
            // 
            // mirrorYToolStripMenuItem
            // 
            this.mirrorYToolStripMenuItem.Name = "mirrorYToolStripMenuItem";
            this.mirrorYToolStripMenuItem.Size = new System.Drawing.Size(188, 22);
            this.mirrorYToolStripMenuItem.Text = "MirrorX Right to Left ";
            // 
            // mirrorYToolStripMenuItem1
            // 
            this.mirrorYToolStripMenuItem1.Name = "mirrorYToolStripMenuItem1";
            this.mirrorYToolStripMenuItem1.Size = new System.Drawing.Size(188, 22);
            this.mirrorYToolStripMenuItem1.Text = "Mirror Y Left To Right";
            // 
            // mirrorYLeftToRightToolStripMenuItem
            // 
            this.mirrorYLeftToRightToolStripMenuItem.Name = "mirrorYLeftToRightToolStripMenuItem";
            this.mirrorYLeftToRightToolStripMenuItem.Size = new System.Drawing.Size(188, 22);
            this.mirrorYLeftToRightToolStripMenuItem.Text = "Mirror Y Right to Left";
            // 
            // pictureBox1
            // 
            this.pictureBox1.Location = new System.Drawing.Point(0, 0);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new System.Drawing.Size(100, 50);
            this.pictureBox1.TabIndex = 0;
            this.pictureBox1.TabStop = false;
            // 
            // graphicButton1
            // 
            this.graphicButton1.BackColor = System.Drawing.Color.Blue;
            this.graphicButton1.BorderThick = 5;
            this.graphicButton1.ButtonSize = new System.Drawing.Size(110, 106);
            this.graphicButton1.ButtonType = UiFramworkLibrary.GraphicButton.ButtonTypeEnum.CircleButton;
            this.graphicButton1.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(255)))), ((int)(((byte)(0)))));
            this.graphicButton1.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.graphicButton1.ForeColor = System.Drawing.Color.DarkGoldenrod;
            this.graphicButton1.GradientAngle = 180;
            this.graphicButton1.HCStartAngle = 0;
            this.graphicButton1.HCSweepAngle = 180;
            this.graphicButton1.HCThick = 20;
            this.graphicButton1.IBorderColors = System.Drawing.Color.Blue;
            this.graphicButton1.IInsideColors = System.Drawing.Color.DarkGoldenrod;
            this.graphicButton1.IMaxScript = null;
            this.graphicButton1.ISelectedColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(255)))), ((int)(((byte)(0)))));
            this.graphicButton1.ISizeHeight = 106;
            this.graphicButton1.ISizeWidth = 110;
            this.graphicButton1.IsSelected = false;
            this.graphicButton1.IText = "Add new Tab   ";
            this.graphicButton1.ITextColor = System.Drawing.Color.White;
            this.graphicButton1.Location = new System.Drawing.Point(434, 24);
            this.graphicButton1.Name = "graphicButton1";
            this.graphicButton1.Position = new System.Drawing.Point(434, 24);
            this.graphicButton1.PositionX = 434;
            this.graphicButton1.PositionY = 24;
            this.graphicButton1.Radius = 30;
            this.graphicButton1.Size = new System.Drawing.Size(110, 106);
            this.graphicButton1.TabIndex = 5;
            this.graphicButton1.Text = "Add new Tab   ";
            this.graphicButton1.UseVisualStyleBackColor = false;
            this.graphicButton1.Click += new System.EventHandler(this.graphicButton1_Click_1);
            // 
            // customPanel1
            // 
            this.customPanel1.BackColor = System.Drawing.SystemColors.ActiveCaption;
            this.customPanel1.Controls.Add(this.tabControl1);
            this.customPanel1.Controls.Add(this.textBox1);
            this.customPanel1.Controls.Add(this.button1);
            this.customPanel1.Controls.Add(this.customPropertyGrid1);
            this.customPanel1.Controls.Add(this.graphicButton3);
            this.customPanel1.Controls.Add(this.graphicButton1);
            this.customPanel1.Iheight = 600;
            this.customPanel1.Iwidth = 800;
            this.customPanel1.Location = new System.Drawing.Point(112, 50);
            this.customPanel1.Name = "customPanel1";
            this.customPanel1.PositionX = 0;
            this.customPanel1.PositionY = 0;
            this.customPanel1.SelectedButtons = new System.Windows.Forms.Button[0];
            this.customPanel1.Size = new System.Drawing.Size(589, 569);
            this.customPanel1.TabIndex = 7;
            this.customPanel1.Scroll += new System.Windows.Forms.ScrollEventHandler(this.customPanel1_Scroll);
            this.customPanel1.Click += new System.EventHandler(this.customPanel_Click);
            this.customPanel1.Paint += new System.Windows.Forms.PaintEventHandler(this.customPanel1_Paint);
            this.customPanel1.MouseUp += new System.Windows.Forms.MouseEventHandler(this.customPanel1_MouseUp);
            // 
            // tabControl1
            // 
            this.tabControl1.Controls.Add(this.tabPage1);
            this.tabControl1.Controls.Add(this.tabPage2);
            this.tabControl1.Location = new System.Drawing.Point(3, 227);
            this.tabControl1.Name = "tabControl1";
            this.tabControl1.SelectedIndex = 0;
            this.tabControl1.Size = new System.Drawing.Size(258, 339);
            this.tabControl1.TabIndex = 13;
            this.tabControl1.MouseClick += new System.Windows.Forms.MouseEventHandler(this.tabControl1_MouseClick);
            this.tabControl1.MouseDown += new System.Windows.Forms.MouseEventHandler(this.tabControl1_MouseDown);
            // 
            // tabPage1
            // 
            this.tabPage1.Controls.Add(this.graphicButton2);
            this.tabPage1.Location = new System.Drawing.Point(4, 22);
            this.tabPage1.Name = "tabPage1";
            this.tabPage1.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage1.Size = new System.Drawing.Size(250, 313);
            this.tabPage1.TabIndex = 0;
            this.tabPage1.Text = "tabPage1";
            this.tabPage1.UseVisualStyleBackColor = true;
            this.tabPage1.MouseDown += new System.Windows.Forms.MouseEventHandler(this.tabPage1_MouseDown);
            // 
            // graphicButton2
            // 
            this.graphicButton2.BackColor = System.Drawing.Color.White;
            this.graphicButton2.BorderThick = 5;
            this.graphicButton2.ButtonSize = new System.Drawing.Size(238, 238);
            this.graphicButton2.ButtonType = UiFramworkLibrary.GraphicButton.ButtonTypeEnum.CircleButton;
            this.graphicButton2.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(255)))), ((int)(((byte)(0)))));
            this.graphicButton2.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.graphicButton2.ForeColor = System.Drawing.Color.Navy;
            this.graphicButton2.GradientAngle = 180;
            this.graphicButton2.HCStartAngle = 0;
            this.graphicButton2.HCSweepAngle = 180;
            this.graphicButton2.HCThick = 20;
            this.graphicButton2.IBorderColors = System.Drawing.Color.White;
            this.graphicButton2.IInsideColors = System.Drawing.Color.Navy;
            this.graphicButton2.IMaxScript = "";
            this.graphicButton2.ISelectedColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(255)))), ((int)(((byte)(0)))));
            this.graphicButton2.ISizeHeight = 238;
            this.graphicButton2.ISizeWidth = 238;
            this.graphicButton2.IsSelected = false;
            this.graphicButton2.IText = "graphicButton2";
            this.graphicButton2.ITextColor = System.Drawing.Color.White;
            this.graphicButton2.Location = new System.Drawing.Point(6, 6);
            this.graphicButton2.Name = "graphicButton2";
            this.graphicButton2.Position = new System.Drawing.Point(6, 6);
            this.graphicButton2.PositionX = 6;
            this.graphicButton2.PositionY = 6;
            this.graphicButton2.Radius = 30;
            this.graphicButton2.Size = new System.Drawing.Size(238, 238);
            this.graphicButton2.TabIndex = 0;
            this.graphicButton2.Text = "graphicButton2";
            this.graphicButton2.UseVisualStyleBackColor = false;
            // 
            // tabPage2
            // 
            this.tabPage2.Location = new System.Drawing.Point(4, 22);
            this.tabPage2.Name = "tabPage2";
            this.tabPage2.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage2.Size = new System.Drawing.Size(250, 313);
            this.tabPage2.TabIndex = 1;
            this.tabPage2.Text = "tabPage2";
            this.tabPage2.UseVisualStyleBackColor = true;
            // 
            // textBox1
            // 
            this.textBox1.Location = new System.Drawing.Point(109, 201);
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new System.Drawing.Size(117, 20);
            this.textBox1.TabIndex = 12;
            this.textBox1.TextChanged += new System.EventHandler(this.textBox1_TextChanged);
            this.textBox1.Enter += new System.EventHandler(this.customPanel_Click);
            this.textBox1.Leave += new System.EventHandler(this.textBox1_Leave);
            // 
            // button1
            // 
            this.button1.BackColor = System.Drawing.Color.Transparent;
            this.button1.FlatStyle = System.Windows.Forms.FlatStyle.Popup;
            this.button1.Location = new System.Drawing.Point(109, 137);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(117, 58);
            this.button1.TabIndex = 11;
            this.button1.Text = "button1";
            this.button1.UseVisualStyleBackColor = false;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // customPropertyGrid1
            // 
            this.customPropertyGrid1.ITags = "";
            this.customPropertyGrid1.Location = new System.Drawing.Point(267, 249);
            this.customPropertyGrid1.Name = "customPropertyGrid1";
            this.customPropertyGrid1.Size = new System.Drawing.Size(319, 317);
            this.customPropertyGrid1.TabIndex = 9;
            // 
            // graphicButton3
            // 
            this.graphicButton3.BackColor = System.Drawing.Color.Blue;
            this.graphicButton3.BorderThick = 5;
            this.graphicButton3.ButtonSize = new System.Drawing.Size(100, 100);
            this.graphicButton3.ButtonType = UiFramworkLibrary.GraphicButton.ButtonTypeEnum.CircleButton;
            this.graphicButton3.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(255)))), ((int)(((byte)(0)))), ((int)(((byte)(50)))));
            this.graphicButton3.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.graphicButton3.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(224)))), ((int)(((byte)(192)))), ((int)(((byte)(50)))));
            this.graphicButton3.GradientAngle = 180;
            this.graphicButton3.HCStartAngle = 0;
            this.graphicButton3.HCSweepAngle = 180;
            this.graphicButton3.HCThick = 20;
            this.graphicButton3.IBorderColors = System.Drawing.Color.Blue;
            this.graphicButton3.IInsideColors = System.Drawing.Color.FromArgb(((int)(((byte)(224)))), ((int)(((byte)(192)))), ((int)(((byte)(50)))));
            this.graphicButton3.IMaxScript = "";
            this.graphicButton3.ISelectedColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(255)))), ((int)(((byte)(0)))), ((int)(((byte)(50)))));
            this.graphicButton3.ISizeHeight = 100;
            this.graphicButton3.ISizeWidth = 100;
            this.graphicButton3.IsSelected = false;
            this.graphicButton3.IText = "graphicButton3";
            this.graphicButton3.ITextColor = System.Drawing.Color.White;
            this.graphicButton3.Location = new System.Drawing.Point(328, 27);
            this.graphicButton3.Name = "graphicButton3";
            this.graphicButton3.Position = new System.Drawing.Point(328, 27);
            this.graphicButton3.PositionX = 328;
            this.graphicButton3.PositionY = 27;
            this.graphicButton3.Radius = 30;
            this.graphicButton3.Size = new System.Drawing.Size(100, 100);
            this.graphicButton3.TabIndex = 7;
            this.graphicButton3.Text = "graphicButton3";
            this.graphicButton3.UseVisualStyleBackColor = false;
            this.graphicButton3.Click += new System.EventHandler(this.graphicButton3_Click);
            // 
            // contextMenuStrip1
            // 
            this.contextMenuStrip1.Name = "contextMenuStrip1";
            this.contextMenuStrip1.Size = new System.Drawing.Size(61, 4);
            // 
            // toolTip1
            // 
            this.toolTip1.Popup += new System.Windows.Forms.PopupEventHandler(this.toolTip1_Popup);
            // 
            // Form1
            // 
            this.ClientSize = new System.Drawing.Size(1077, 693);
            this.Controls.Add(this.customPanel1);
            this.Controls.Add(this.propertyGrid1);
            this.Controls.Add(this.menuStrip1);
            this.MainMenuStrip = this.menuStrip1;
            this.Name = "Form1";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.ResizeEnd += new System.EventHandler(this.Form1_ResizeEnd);
            this.SizeChanged += new System.EventHandler(this.Form1_SizeChanged);
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this.Form1_KeyDown);
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
            this.customPanel1.ResumeLayout(false);
            this.customPanel1.PerformLayout();
            this.tabControl1.ResumeLayout(false);
            this.tabPage1.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        private void graphicButton1_Click(object sender, EventArgs e)
        {
            //((GraphicButton)sender).IsSelected = !((GraphicButton)sender).IsSelected;
        }

        private PropertyGrid propertyGrid1;

        private MenuStrip menuStrip1;
        private ToolStripMenuItem alignToolStripMenuItem;
        private ToolStripMenuItem centerToolStripMenuItem;
        private ToolStripMenuItem mirrorXToolStripMenuItem;
        private ToolStripMenuItem mirrorYToolStripMenuItem;
        private ToolStripMenuItem mirrorYToolStripMenuItem1;
        private ToolStripMenuItem mirrorYLeftToRightToolStripMenuItem;

        private PictureBox pictureBox1;

        public Panel mypan = new Panel();
        private GraphicButton graphicButton1;
        private GraphicButton graphicButton3;
        private CustomPanel customPanel1;

        private void customPanel1_MouseUp(object sender, MouseEventArgs e)
        {
            foreach (GraphicButton Btn in customPanel1.SelectedButtons )
            {
                Btn.IsSelected = true;
            }
        }
        private void Form1_Load(object sender, EventArgs e)
        {
            ControlMoverOrResizer.Init(graphicButton1);
            ControlMoverOrResizer.Init(graphicButton3);
            ControlMoverOrResizer.IContainer = customPanel1;
        }
        private void customPanel_Click(object sender, EventArgs e)
        {

        }
        private ContextMenuStrip contextMenuStrip1;
        private IContainer components;

        private void graphicButton1_Click_1(object sender, EventArgs e)
        {
            customPropertyGrid1.SelectedObject = sender;
            tabControl1.TabPages.Add("NewTabAdded");
            
            


        }

        private CustomPropertyGrid customPropertyGrid1;

        private void graphicButton3_Click(object sender, EventArgs e)
        {
            
            customPropertyGrid1.SelectedObject = graphicButton3.GetWrapper;
        }

        private Button button1;

        private void button1_Click(object sender, EventArgs e)
        {
            SetStyle(ControlStyles.SupportsTransparentBackColor, true);
            SetStyle(ControlStyles.UserPaint, true);
            SetStyle(ControlStyles.Opaque, true);
            this.BackColor = Color.Transparent;
        }

        private TextBox textBox1;

        private void textBox1_Leave(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private TabControl tabControl1;
        private TabPage tabPage1;
        private TabPage tabPage2;
        private GraphicButton graphicButton2;

        private void tabControl1_MouseClick(object sender, MouseEventArgs e)
        {

        }

        private void tabControl1_MouseDown(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Right) { MessageBox.Show("RightClick"); }
            if (e.Button == MouseButtons.Left) { MessageBox.Show("LeftClick"); }
            if (e.Button == MouseButtons.Middle) { MessageBox.Show("MiddleClick"); }


        }

        private void tabPage1_MouseDown(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Right) { MessageBox.Show("RightClick"); }
            if (e.Button == MouseButtons.Left) { MessageBox.Show("LeftClick"); }
            if (e.Button == MouseButtons.Middle) { MessageBox.Show("MiddleClick"); }
        }

        private void customPanel1_Paint(object sender, PaintEventArgs e)
        {
            
        }

        private void Form1_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.A)
            {
                e.SuppressKeyPress = true;
                MessageBox.Show(sender.ToString());
            }
            
        }

        private void panel1_Paint(object sender, PaintEventArgs e)
        {

        }

        private ToolTip toolTip1;

        private void toolTip1_Popup(object sender, PopupEventArgs e)
        {
            
        }

        private void Form1_ResizeEnd(object sender, EventArgs e)
        {
            this.Text = (this.Size.Width.ToString())+@"     "+(this.Size.Height.ToString());
        }

        private void Form1_SizeChanged(object sender, EventArgs e)
        {
            this.Text = (this.Size.Width.ToString()) + @"     " + (this.Size.Height.ToString());
        }

        private void customPanel1_Scroll(object sender, ScrollEventArgs e)
        {
            MessageBox.Show(e.ToString());
            //SizeF sizeF = new SizeF(e.NewValue, e.NewValue);
            //customPanel1.Scale(sizeF);
        }
    }
}
