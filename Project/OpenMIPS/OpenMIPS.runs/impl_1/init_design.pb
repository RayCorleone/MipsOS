
~
Command: %s
53*	vivadotcl2M
9link_design -top openmips_min_sopc -part xc7a100tcsg324-12default:defaultZ4-113h px� 
g
#Design is defaulting to srcset: %s
437*	planAhead2
	sources_12default:defaultZ12-437h px� 
j
&Design is defaulting to constrset: %s
434*	planAhead2
	constrs_12default:defaultZ12-434h px� 
W
Loading part %s157*device2$
xc7a100tcsg324-12default:defaultZ21-403h px� 
�
-Reading design checkpoint '%s' for cell '%s'
275*project2]
Id:/Ray/Vivado/OpenMIPS/OpenMIPS.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.dcp2default:default2

DDR2/clk_12default:defaultZ1-454h px� 
�
-Reading design checkpoint '%s' for cell '%s'
275*project2e
Qd:/Ray/Vivado/OpenMIPS/OpenMIPS.srcs/sources_1/ip/mig_7series_0/mig_7series_0.dcp2default:default2%
DDR2/Ram/Inst_DDR2default:defaultZ1-454h px� 
g
-Analyzing %s Unisim elements for replacement
17*netlist2
5682default:defaultZ29-17h px� 
j
2Unisim Transformation completed in %s CPU seconds
28*netlist2
12default:defaultZ29-28h px� 
x
Netlist was created with %s %s291*project2
Vivado2default:default2
2019.12default:defaultZ1-479h px� 
K
)Preparing netlist for logic optimization
349*projectZ1-570h px� 
�
LRemoving redundant IBUF, %s, from the path connected to top-level port: %s 
35*opt20
DDR2/clk_1/inst/clkin1_ibufg2default:default2
clk_in2default:defaultZ31-35h px� 
�
�Could not create '%s' constraint because net '%s' is not directly connected to top level port. Synthesis is ignored for %s but preserved for implementation.
528*constraints2 
IBUF_LOW_PWR2default:default2(
DDR2/clk_1/clk_in12default:default2 
IBUF_LOW_PWR2default:default8Z18-550h px� 
�
$Parsing XDC File [%s] for cell '%s'
848*designutils2�
wd:/Ray/Vivado/OpenMIPS/OpenMIPS.srcs/sources_1/ip/mig_7series_0/mig_7series_0/user_design/constraints/mig_7series_0.xdc2default:default2'
DDR2/Ram/Inst_DDR	2default:default8Z20-848h px� 
�
-Finished Parsing XDC File [%s] for cell '%s'
847*designutils2�
wd:/Ray/Vivado/OpenMIPS/OpenMIPS.srcs/sources_1/ip/mig_7series_0/mig_7series_0/user_design/constraints/mig_7series_0.xdc2default:default2'
DDR2/Ram/Inst_DDR	2default:default8Z20-847h px� 
�
$Parsing XDC File [%s] for cell '%s'
848*designutils2e
Od:/Ray/Vivado/OpenMIPS/OpenMIPS.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_board.xdc2default:default2%
DDR2/clk_1/inst	2default:default8Z20-848h px� 
�
-Finished Parsing XDC File [%s] for cell '%s'
847*designutils2e
Od:/Ray/Vivado/OpenMIPS/OpenMIPS.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_board.xdc2default:default2%
DDR2/clk_1/inst	2default:default8Z20-847h px� 
�
$Parsing XDC File [%s] for cell '%s'
848*designutils2_
Id:/Ray/Vivado/OpenMIPS/OpenMIPS.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc2default:default2%
DDR2/clk_1/inst	2default:default8Z20-848h px� 
�
%Done setting XDC timing constraints.
35*timing2_
Id:/Ray/Vivado/OpenMIPS/OpenMIPS.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc2default:default2
572default:default8@Z38-35h px� 
�
Deriving generated clocks
2*timing2_
Id:/Ray/Vivado/OpenMIPS/OpenMIPS.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc2default:default2
572default:default8@Z38-2h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2 
get_clocks: 2default:default2
00:00:122default:default2
00:00:122default:default2
1266.9772default:default2
533.0782default:defaultZ17-268h px� 
�
-Finished Parsing XDC File [%s] for cell '%s'
847*designutils2_
Id:/Ray/Vivado/OpenMIPS/OpenMIPS.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc2default:default2%
DDR2/clk_1/inst	2default:default8Z20-847h px� 
�
Parsing XDC File [%s]
179*designutils2V
@D:/Ray/Vivado/OpenMIPS/OpenMIPS.srcs/constrs_1/new/nexys4ddr.xdc2default:default8Z20-179h px� 
�
Finished Parsing XDC File [%s]
178*designutils2V
@D:/Ray/Vivado/OpenMIPS/OpenMIPS.srcs/constrs_1/new/nexys4ddr.xdc2default:default8Z20-178h px� 
u
)Pushed %s inverter(s) to %s load pin(s).
98*opt2
02default:default2
02default:defaultZ31-138h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2 
00:00:00.0102default:default2
1266.9772default:default2
0.0002default:defaultZ17-268h px� 
�
!Unisim Transformation Summary:
%s111*project2�
�  A total of 139 instances were transformed.
  IOBUFDS_INTERMDISABLE => IOBUFDS_INTERMDISABLE (IBUFDS_INTERMDISABLE_INT, IBUFDS_INTERMDISABLE_INT, INV, OBUFTDS, OBUFTDS): 2 instances
  IOBUF_INTERMDISABLE => IOBUF_INTERMDISABLE (IBUF_INTERMDISABLE, OBUFT): 16 instances
  OBUFDS => OBUFDS_DUAL_BUF (INV, OBUFDS, OBUFDS): 1 instances
  RAM32M => RAM32M (RAMD32, RAMD32, RAMD32, RAMD32, RAMD32, RAMD32, RAMS32, RAMS32): 120 instances
2default:defaultZ1-111h px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
112default:default2
22default:default2
02default:default2
02default:defaultZ4-41h px� 
]
%s completed successfully
29*	vivadotcl2
link_design2default:defaultZ4-42h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2!
link_design: 2default:default2
00:00:242default:default2
00:00:242default:default2
1266.9772default:default2
975.4802default:defaultZ17-268h px� 


End Record