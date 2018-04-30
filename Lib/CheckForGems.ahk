CheckForGems()
	{
	CheckForGems:
	Global
	PixelSearch, SapphireX, SapphireY, ox+121, oy+78, ox+395, oy+235, 0x840a07, 3, Fast ;check for sapphires
		if ErrorLevel = 0
			{
			Random, wait200to900milis, 200, 900
			Sleep, wait200to900milis
				Random, varyby5, -5, 5
				Random, varyby7, -7, 7
				MouseMove, SapphireX+varyby7+7, SapphireY+varyby5+10, 0
					Random, wait200to900milis, 200, 900
					Sleep, wait200to900milis
						Click, down
							Random, wait5to150milis, 5, 150
							Sleep, wait5to150milis
						Click, up
					Random, wait700to900milis, 700, 900
					Sleep, wait700to900milis
						Random, DoubleClickRoll, 1, 10 ;chance to double-click on gem
							if DoubleClickRoll = 1
								{
								Random, wait90to250milis, 90, 250
								Sleep, wait90to250milis
									Click, down
										Random, wait5to150milis, 5, 150
										Sleep, wait5to150milis
									Click, up
								}
			Goto, CheckForGems
			}
		else
			{
			PixelSearch, EmeraldX,EmeraldY, ox+121, oy+78, ox+395, oy+235, 0x0a7b06, 3, Fast ;check for emeralds
				if ErrorLevel = 0
					{
					Random, wait200to900milis, 200, 900
					Sleep, wait200to900milis
						Random, varyby5, -5, 5
						Random, varyby7, -7, 7
						MouseMove, EmeraldX+varyby7+7, EmeraldY+varyby5+10, 0
							Random, wait200to900milis, 200, 900
							Sleep, wait200to900milis
								Click, down
									Random, wait5to150milis, 5, 150
									Sleep, wait5to150milis
								Click, up
							Random, wait700to900milis, 700, 900
							Sleep, wait700to900milis
								Random, DoubleClickRoll, 1, 10 ;chance to double-click on gem
									if DoubleClickRoll = 1
										{
										Random, wait90to250milis, 90, 250
										Sleep, wait90to250milis
											Click, down
												Random, wait5to150milis, 5, 150
												Sleep, wait5to150milis
											Click, up
										}
					Goto, CheckForGems
					}
				else
					{
					PixelSearch, RubyX,RubyY, ox+121, oy+78, ox+395, oy+235, 0x050c68, 3, Fast ;check for rubies
						if ErrorLevel = 0
							{
							Random, wait200to900milis, 200, 900
							Sleep, wait200to900milis
								Random, varyby5, -5, 5
								Random, varyby7, -7, 7
								MouseMove, RubyX+varyby7+7, RubyY+varyby5+10, 0
									Random, wait200to900milis, 200, 900
									Sleep, wait200to900milis
										Click, down
											Random, wait5to150milis, 5, 150
											Sleep, wait5to150milis
										Click, up
									Random, wait700to900milis, 700, 900
									Sleep, wait700to900milis
										Random, DoubleClickRoll, 1, 10 ;chance to double-click on gem
											if DoubleClickRoll = 1
												{
												Random, wait90to250milis, 90, 250
												Sleep, wait90to250milis
													Click, down
														Random, wait5to150milis, 5, 150
														Sleep, wait5to150milis
													Click, up
												}
							Goto, CheckForGems
							}
						else
							{
							PixelSearch, DiamondX, DiamondY, ox+121, oy+78, ox+395, oy+235, 0xafafb1, 3, Fast ;check for diamonds
								if ErrorLevel = 0
									{
									Random, wait200to900milis, 200, 900
									Sleep, wait200to900milis
										Random, varyby5, -5, 5
										Random, varyby7, -7, 7
										MouseMove, DiamondX+varyby7+7, DiamondY+varyby5+10, 0
											Random, wait200to900milis, 200, 900
											Sleep, wait200to900milis
												Click, down
													Random, wait5to150milis, 5, 150
													Sleep, wait5to150milis
												Click, up
											Random, wait700to900milis, 700, 900
											Sleep, wait700to900milis
												Random, DoubleClickRoll, 1, 10 ;chance to double-click on gem
													if DoubleClickRoll = 1
														{
														Random, wait90to250milis, 90, 250
														Sleep, wait90to250milis
															Click, down
																Random, wait5to150milis, 5, 150
																Sleep, wait5to150milis
															Click, up
														}
									Goto, CheckForGems
									}
								else
									Return
							}
							
					}
			}
	}

	