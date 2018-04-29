
		if ErrorLevel ;if not at mining spot, check if stuck at NW corner
									{
									PixelSearch, StuckNWX, StuckNWY, ox+640, oy+159, ox+640, oy+159, 0x0000ef, 15, Fast
										if ErrorLevel = 0
											{
											Random, varyby9, -9, 9
											Random, varyby9, -8, 8
											MouseMove, ox+varyby9+285, oy+varyby8+204, 0 ;mining spot from StuckNW position
												Random, wait200to900milis, 200, 900 
												Sleep, wait200to900milis
													Click, down
														Random, wait5to150milis, 5, 150
														Sleep, wait5to150milis
													Click, up
														Random, DoubleClickRoll, 1, 10 ;chance to double-click on mining spot
															if DoubleClickRoll = 1
																{
																	Random, wait90to250milis, 90, 250
																	Sleep, wait90to250milis
																		Click, down
																			Random, wait5to150milis, 5, 150
																			Sleep, wait5to150milis
																		Click, up
																}
														Random, wait2to4sec, 2000, 4000
														Sleep, wait2to4sec
															Goto, GoingtoMiningSpot
											}
										else ;check if stuck at SW corner
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
																Random, DoubleClickRoll, 1, 10 ;chance to double-click on mining spot
																	if DoubleClickRoll = 1
																		{
																			Random, wait90to250milis, 90, 250
																			Sleep, wait90to250milis
																				Click, down
																					Random, wait5to150milis, 5, 150
																					Sleep, wait5to150milis
																				Click, up
																		}
																Random, wait2to4sec, 2000, 4000
																Sleep, wait2to4sec
																	Goto, GoingtoMiningSpot
													}
												else ;check if stuck one tile E of mining spot
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
																		Random, DoubleClickRoll, 1, 10 ;chance to double-click on mining spot
																			if DoubleClickRoll = 1
																				{
																					Random, wait90to250milis, 90, 250
																					Sleep, wait90to250milis
																						Click, down
																							Random, wait5to150milis, 5, 150
																							Sleep, wait5to150milis
																						Click, up
																				}
																		Random, wait2to4sec, 2000, 4000
																		Sleep, wait2to4sec
																			Goto, GoingtoMiningSpot
															}
														else ;check if stuck at NE corner
															{
															PixelSearch, StuckNEX, StuckNEY, ox+664, oy+142, ox+664, oy+142, 0x0000f2, 15, Fast
																if ErrorLevel = 0
																	{
																	Random, varyby12, -12, 12
																	Random, varyby11, -11, 11
																	MouseMove, ox+varyby12+203, oy+varyby11+201, 0 ;mining spot from StuckNE position
																		Random, wait200to900milis, 200, 900 
																		Sleep, wait200to900milis
																			Click, down
																				Random, wait5to150milis, 5, 150
																				Sleep, wait5to150milis
																			Click, up
																				Random, DoubleClickRoll, 1, 10 ;chance to double-click on mining spot
																					if DoubleClickRoll = 1
																						{
																							Random, wait90to250milis, 90, 250
																							Sleep, wait90to250milis
																								Click, down
																									Random, wait5to150milis, 5, 150
																									Sleep, wait5to150milis
																								Click, up
																						}
																				Random, wait2to4sec, 2000, 4000
																				Sleep, wait2to4sec
																					Goto, GoingtoMiningSpot
																	}
																else ;if not at mining spot yet, wait before checking spots again, wait 10-20sec in total before giving up
																	{
																	Random, wait100to200milis, 100, 200
																	Sleep, wait100to200milis
																	}
															
															}
													}
											}
									}
*/