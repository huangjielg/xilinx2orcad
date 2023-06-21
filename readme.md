# XILINX2ORCAD

 把XILINX的pkg文件转换为orcad库符号。
 例如A7的可以从这里下载
 https://china.xilinx.com/support/package-pinout-files/artix-7-pkgs.html

# tcl 参考手册 
 \tools\capture\tclscripts\OrCAD_Capture_TclTk_Extensions.pdf
 
# 向原理图中添加网表

  1. 使用 pin2dict 生成Table.tcl
  2. 在orcad命令窗口中 source AddNetsToParts.tcl
  4. 选中FPGA .右键 菜单 more ，AddNetsToParts
  就会添加网络名，如果已经有连接，则不覆盖。