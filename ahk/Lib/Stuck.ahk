
 
		if ErrorLevel ;if not at furnace, check if stuck one tile north
									{
									PixelSearch, StuckNX, StuckNY, ox+640, oy+159, ox+640, oy+159, 0x0000ef, 15, Fast
										if ErrorLevel = 0
											{
											Random, varyby9, -9, 9
											Random, varyby9, -8, 8
											MouseMove, ox+varyby9+285, oy+varyby8+204, 0 
												Random, wait200to900milis, 200, 900 
												Sleep, wait200to900milis
													Click, down
														Random, wait5to150milis, 5, 150
														Sleep, wait5to150milis
													Click, up
														Random, wait2to4sec, 2000, 4000
														Sleep, wait2to4sec
															Goto, FurnaceAtCheck
											}
										else ;if not stuck one tile north, check if stuck one tile south
											{
											PixelSearch, StuckSWX, StuckSWY, ox+635, oy+138, ox+635, oy+138, 0x0000f5, 15, Fast
												if ErrorLevel = 0
													{
													Random, varyby8, -8, 8
													Random, varyby7, -7, 7
													MouseMove, ox+varyby8+284, oy+varyby7+146, 0 ;mining spot from StuckSW position
														Random, wait200to900milis, 200, 900 
														Sleep, wait200to900milis
															Click, down
																Random, wait5to150milis, 5, 150
																Sleep, wait5to150milis
															Click, up
																Random, wait2to4sec, 2000, 4000
																Sleep, wait2to4sec
																	Goto, FurnaceAtCheck
													}
												else ;if not stuck one tile north or south, check if stuck one tile west
													{
													PixelSearch, StuckEX, StuckEY, ox+628, oy+38, ox+628, oy+38, 0x0000e9, 15, Fast
														if ErrorLevel = 0
															{
															Random, varyby9, -9, 9
															Random, varyby8, -8, 8
															MouseMove, ox+varyby9+208, oy+varyby8+171, 0 ;mining spot from StuckSW position
																Random, wait200to900milis, 200, 900 
																Sleep, wait200to900milis
																	Click, down
																		Random, wait5to150milis, 5, 150
																		Sleep, wait5to150milis
																	Click, up
																		Random, wait2to4sec, 2000, 4000
																		Sleep, wait2to4sec
																			Goto, FurnaceAtCheck
															}
																	}
																else ;if not at furnace and not stuck at any known location, logout
																	{
																	Random, wait100to200milis, 100, 200
																	Sleep, wait100to200milis
																	}
															
															}
													}
											}
									}
*/
