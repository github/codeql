package css

// uses github.com/tdewolff/hasher
//go:generate hasher -type=Hash -file=hash.go

// Hash defines perfect hashes for a predefined list of strings
type Hash uint32

// Identifiers for the hashes associated with the text in the comments.
const (
	Ms_Filter                   Hash = 0xa     // -ms-filter
	Accelerator                 Hash = 0x3760b // accelerator
	Aliceblue                   Hash = 0x7a209 // aliceblue
	Align_Content               Hash = 0xd980d // align-content
	Align_Items                 Hash = 0x7ef0b // align-items
	Align_Self                  Hash = 0x8cb0a // align-self
	All                         Hash = 0x69103 // all
	Alpha                       Hash = 0x37205 // alpha
	Animation                   Hash = 0xca09  // animation
	Animation_Delay             Hash = 0x2050f // animation-delay
	Animation_Direction         Hash = 0x8e913 // animation-direction
	Animation_Duration          Hash = 0x35d12 // animation-duration
	Animation_Fill_Mode         Hash = 0x66c13 // animation-fill-mode
	Animation_Iteration_Count   Hash = 0xd4919 // animation-iteration-count
	Animation_Name              Hash = 0xca0e  // animation-name
	Animation_Play_State        Hash = 0xfc14  // animation-play-state
	Animation_Timing_Function   Hash = 0x14119 // animation-timing-function
	Antiquewhite                Hash = 0x6490c // antiquewhite
	Aquamarine                  Hash = 0x9ec0a // aquamarine
	Attr                        Hash = 0x59804 // attr
	Auto                        Hash = 0x44504 // auto
	Azimuth                     Hash = 0x15a07 // azimuth
	Background                  Hash = 0x2b0a  // background
	Background_Attachment       Hash = 0x2b15  // background-attachment
	Background_Clip             Hash = 0xb6e0f // background-clip
	Background_Color            Hash = 0x21710 // background-color
	Background_Image            Hash = 0x5ad10 // background-image
	Background_Origin           Hash = 0x17111 // background-origin
	Background_Position         Hash = 0x18e13 // background-position
	Background_Position_X       Hash = 0x18e15 // background-position-x
	Background_Position_Y       Hash = 0x1a315 // background-position-y
	Background_Repeat           Hash = 0x1b811 // background-repeat
	Background_Size             Hash = 0x1cb0f // background-size
	Behavior                    Hash = 0x1da08 // behavior
	Black                       Hash = 0x1e205 // black
	Blanchedalmond              Hash = 0x1e70e // blanchedalmond
	Blueviolet                  Hash = 0x7a70a // blueviolet
	Bold                        Hash = 0x1fc04 // bold
	Border                      Hash = 0x22706 // border
	Border_Bottom               Hash = 0x2270d // border-bottom
	Border_Bottom_Color         Hash = 0x22713 // border-bottom-color
	Border_Bottom_Style         Hash = 0x23a13 // border-bottom-style
	Border_Bottom_Width         Hash = 0x25d13 // border-bottom-width
	Border_Box                  Hash = 0x27e0a // border-box
	Border_Collapse             Hash = 0x2b60f // border-collapse
	Border_Color                Hash = 0x2d30c // border-color
	Border_Left                 Hash = 0x2df0b // border-left
	Border_Left_Color           Hash = 0x2df11 // border-left-color
	Border_Left_Style           Hash = 0x2f011 // border-left-style
	Border_Left_Width           Hash = 0x30111 // border-left-width
	Border_Right                Hash = 0x3120c // border-right
	Border_Right_Color          Hash = 0x31212 // border-right-color
	Border_Right_Style          Hash = 0x32412 // border-right-style
	Border_Right_Width          Hash = 0x33612 // border-right-width
	Border_Spacing              Hash = 0x3480e // border-spacing
	Border_Style                Hash = 0x3ab0c // border-style
	Border_Top                  Hash = 0x3b70a // border-top
	Border_Top_Color            Hash = 0x3b710 // border-top-color
	Border_Top_Style            Hash = 0x3c710 // border-top-style
	Border_Top_Width            Hash = 0x3d710 // border-top-width
	Border_Width                Hash = 0x3e70c // border-width
	Bottom                      Hash = 0x22e06 // bottom
	Box_Shadow                  Hash = 0x2850a // box-shadow
	Burlywood                   Hash = 0x3f309 // burlywood
	Cadetblue                   Hash = 0x9c609 // cadetblue
	Calc                        Hash = 0x9c304 // calc
	Caption_Side                Hash = 0x40f0c // caption-side
	Caret_Color                 Hash = 0x4240b // caret-color
	Center                      Hash = 0xdb06  // center
	Charset                     Hash = 0x62f07 // charset
	Chartreuse                  Hash = 0x42f0a // chartreuse
	Chocolate                   Hash = 0x43909 // chocolate
	Clamp                       Hash = 0x44e05 // clamp
	Clear                       Hash = 0x45d05 // clear
	Clip                        Hash = 0xb7904 // clip
	Cm                          Hash = 0x53802 // cm
	Color                       Hash = 0x2505  // color
	Column_Count                Hash = 0x4620c // column-count
	Column_Gap                  Hash = 0x6a30a // column-gap
	Column_Rule                 Hash = 0x4880b // column-rule
	Column_Rule_Color           Hash = 0x48811 // column-rule-color
	Column_Rule_Style           Hash = 0x49911 // column-rule-style
	Column_Rule_Width           Hash = 0x4aa11 // column-rule-width
	Column_Width                Hash = 0x4bb0c // column-width
	Columns                     Hash = 0x74607 // columns
	Content                     Hash = 0x5607  // content
	Cornflowerblue              Hash = 0x4c70e // cornflowerblue
	Cornsilk                    Hash = 0x4d508 // cornsilk
	Counter_Increment           Hash = 0xd5d11 // counter-increment
	Counter_Reset               Hash = 0x4690d // counter-reset
	Cue                         Hash = 0x4dd03 // cue
	Cue_After                   Hash = 0x4dd09 // cue-after
	Cue_Before                  Hash = 0x4e60a // cue-before
	Currentcolor                Hash = 0x5010c // currentcolor
	Cursive                     Hash = 0x50d07 // cursive
	Cursor                      Hash = 0x51406 // cursor
	Darkblue                    Hash = 0x1f408 // darkblue
	Darkcyan                    Hash = 0x1ff08 // darkcyan
	Darkgoldenrod               Hash = 0x3fb0d // darkgoldenrod
	Darkgray                    Hash = 0x40708 // darkgray
	Darkgreen                   Hash = 0x75c09 // darkgreen
	Darkkhaki                   Hash = 0xa1409 // darkkhaki
	Darkmagenta                 Hash = 0xce90b // darkmagenta
	Darkolivegreen              Hash = 0x6d90e // darkolivegreen
	Darkorange                  Hash = 0x7500a // darkorange
	Darkorchid                  Hash = 0xa0b0a // darkorchid
	Darksalmon                  Hash = 0xa990a // darksalmon
	Darkseagreen                Hash = 0xb110c // darkseagreen
	Darkslateblue               Hash = 0xc1c0d // darkslateblue
	Darkslategray               Hash = 0xbfa0d // darkslategray
	Darkturquoise               Hash = 0xcaa0d // darkturquoise
	Darkviolet                  Hash = 0x51a0a // darkviolet
	Deeppink                    Hash = 0x67d08 // deeppink
	Deepskyblue                 Hash = 0x4190b // deepskyblue
	Default                     Hash = 0xa2207 // default
	Deg                         Hash = 0x70103 // deg
	Direction                   Hash = 0x8d909 // direction
	Display                     Hash = 0xcce07 // display
	Document                    Hash = 0x52408 // document
	Dodgerblue                  Hash = 0x52c0a // dodgerblue
	Dpcm                        Hash = 0x53604 // dpcm
	Dpi                         Hash = 0x54f03 // dpi
	Dppx                        Hash = 0x55b04 // dppx
	Elevation                   Hash = 0x6d09  // elevation
	Empty_Cells                 Hash = 0x3910b // empty-cells
	Env                         Hash = 0x4f503 // env
	Fantasy                     Hash = 0x3a407 // fantasy
	Fill                        Hash = 0x67604 // fill
	Filter                      Hash = 0x406   // filter
	Firebrick                   Hash = 0x83509 // firebrick
	Flex                        Hash = 0x55f04 // flex
	Flex_Basis                  Hash = 0x89d0a // flex-basis
	Flex_Direction              Hash = 0x8d40e // flex-direction
	Flex_Flow                   Hash = 0xc8709 // flex-flow
	Flex_Grow                   Hash = 0x55f09 // flex-grow
	Flex_Shrink                 Hash = 0x5680b // flex-shrink
	Flex_Wrap                   Hash = 0x57309 // flex-wrap
	Float                       Hash = 0x59505 // float
	Floralwhite                 Hash = 0x5bd0b // floralwhite
	Font                        Hash = 0x25404 // font
	Font_Face                   Hash = 0x25409 // font-face
	Font_Family                 Hash = 0x5ee0b // font-family
	Font_Size                   Hash = 0x5f909 // font-size
	Font_Size_Adjust            Hash = 0x5f910 // font-size-adjust
	Font_Stretch                Hash = 0x6250c // font-stretch
	Font_Style                  Hash = 0x6360a // font-style
	Font_Variant                Hash = 0x6400c // font-variant
	Font_Weight                 Hash = 0x65b0b // font-weight
	Forestgreen                 Hash = 0x4ec0b // forestgreen
	Fuchsia                     Hash = 0x66607 // fuchsia
	Function                    Hash = 0x15208 // function
	Gainsboro                   Hash = 0xec09  // gainsboro
	Ghostwhite                  Hash = 0x2990a // ghostwhite
	Goldenrod                   Hash = 0x3ff09 // goldenrod
	Grad                        Hash = 0x1004  // grad
	Greenyellow                 Hash = 0x7600b // greenyellow
	Grid                        Hash = 0x35504 // grid
	Grid_Area                   Hash = 0x35509 // grid-area
	Grid_Auto_Columns           Hash = 0x7bb11 // grid-auto-columns
	Grid_Auto_Flow              Hash = 0x81c0e // grid-auto-flow
	Grid_Auto_Rows              Hash = 0x8640e // grid-auto-rows
	Grid_Column                 Hash = 0x69e0b // grid-column
	Grid_Column_End             Hash = 0xcdb0f // grid-column-end
	Grid_Column_Gap             Hash = 0x69e0f // grid-column-gap
	Grid_Column_Start           Hash = 0x6bd11 // grid-column-start
	Grid_Row                    Hash = 0x6ce08 // grid-row
	Grid_Row_End                Hash = 0x6ce0c // grid-row-end
	Grid_Row_Gap                Hash = 0x6e70c // grid-row-gap
	Grid_Row_Start              Hash = 0x7030e // grid-row-start
	Grid_Template               Hash = 0x7110d // grid-template
	Grid_Template_Areas         Hash = 0x71113 // grid-template-areas
	Grid_Template_Columns       Hash = 0x73815 // grid-template-columns
	Grid_Template_Rows          Hash = 0x77012 // grid-template-rows
	Height                      Hash = 0x9306  // height
	Honeydew                    Hash = 0x16008 // honeydew
	Hsl                         Hash = 0x26f03 // hsl
	Hsla                        Hash = 0x26f04 // hsla
	Hz                          Hash = 0x68502 // hz
	Ime_Mode                    Hash = 0xa1c08 // ime-mode
	Import                      Hash = 0x78d06 // import
	Important                   Hash = 0x78d09 // important
	In                          Hash = 0x4402  // in
	Include_Source              Hash = 0x1800e // include-source
	Indianred                   Hash = 0xb0909 // indianred
	Inherit                     Hash = 0x79607 // inherit
	Initial                     Hash = 0x79d07 // initial
	Invert                      Hash = 0x7e406 // invert
	Justify_Content             Hash = 0x4e0f  // justify-content
	Justify_Items               Hash = 0x6050d // justify-items
	Justify_Self                Hash = 0x82a0c // justify-self
	Keyframes                   Hash = 0x5cb09 // keyframes
	Khz                         Hash = 0x68403 // khz
	Large                       Hash = 0xa905  // large
	Larger                      Hash = 0xa906  // larger
	Lavender                    Hash = 0x27108 // lavender
	Lavenderblush               Hash = 0x2710d // lavenderblush
	Lawngreen                   Hash = 0x2ca09 // lawngreen
	Layer_Background_Color      Hash = 0x21116 // layer-background-color
	Layer_Background_Image      Hash = 0x5a716 // layer-background-image
	Layout_Flow                 Hash = 0xcf80b // layout-flow
	Layout_Grid                 Hash = 0x8050b // layout-grid
	Layout_Grid_Char            Hash = 0x80510 // layout-grid-char
	Layout_Grid_Char_Spacing    Hash = 0x80518 // layout-grid-char-spacing
	Layout_Grid_Line            Hash = 0x83e10 // layout-grid-line
	Layout_Grid_Mode            Hash = 0x85410 // layout-grid-mode
	Layout_Grid_Type            Hash = 0x88710 // layout-grid-type
	Left                        Hash = 0x2e604 // left
	Lemonchiffon                Hash = 0x24b0c // lemonchiffon
	Letter_Spacing              Hash = 0x7ae0e // letter-spacing
	Lightblue                   Hash = 0x8ba09 // lightblue
	Lightcoral                  Hash = 0x8c30a // lightcoral
	Lightcyan                   Hash = 0x8e209 // lightcyan
	Lightgoldenrodyellow        Hash = 0x8fc14 // lightgoldenrodyellow
	Lightgray                   Hash = 0x91009 // lightgray
	Lightgreen                  Hash = 0x9190a // lightgreen
	Lightpink                   Hash = 0x92309 // lightpink
	Lightsalmon                 Hash = 0x92c0b // lightsalmon
	Lightseagreen               Hash = 0x9370d // lightseagreen
	Lightskyblue                Hash = 0x9440c // lightskyblue
	Lightslateblue              Hash = 0x9500e // lightslateblue
	Lightsteelblue              Hash = 0x95e0e // lightsteelblue
	Lightyellow                 Hash = 0x96c0b // lightyellow
	Limegreen                   Hash = 0x97709 // limegreen
	Line_Break                  Hash = 0x84a0a // line-break
	Line_Height                 Hash = 0x8e0b  // line-height
	Linear_Gradient             Hash = 0x9800f // linear-gradient
	List_Style                  Hash = 0x98f0a // list-style
	List_Style_Image            Hash = 0x98f10 // list-style-image
	List_Style_Position         Hash = 0x99f13 // list-style-position
	List_Style_Type             Hash = 0x9b20f // list-style-type
	Local                       Hash = 0x9c105 // local
	Magenta                     Hash = 0xced07 // magenta
	Margin                      Hash = 0x53906 // margin
	Margin_Bottom               Hash = 0xdb10d // margin-bottom
	Margin_Left                 Hash = 0xdbd0b // margin-left
	Margin_Right                Hash = 0xb890c // margin-right
	Margin_Top                  Hash = 0x5390a // margin-top
	Marker_Offset               Hash = 0xad00d // marker-offset
	Marks                       Hash = 0xaee05 // marks
	Mask                        Hash = 0x9cf04 // mask
	Max                         Hash = 0x9d303 // max
	Max_Height                  Hash = 0x9d30a // max-height
	Max_Width                   Hash = 0x9dd09 // max-width
	Media                       Hash = 0xd4505 // media
	Medium                      Hash = 0x9e606 // medium
	Mediumaquamarine            Hash = 0x9e610 // mediumaquamarine
	Mediumblue                  Hash = 0x9f60a // mediumblue
	Mediumorchid                Hash = 0xa000c // mediumorchid
	Mediumpurple                Hash = 0xa420c // mediumpurple
	Mediumseagreen              Hash = 0xa4e0e // mediumseagreen
	Mediumslateblue             Hash = 0xa5c0f // mediumslateblue
	Mediumspringgreen           Hash = 0xa6b11 // mediumspringgreen
	Mediumturquoise             Hash = 0xa7c0f // mediumturquoise
	Mediumvioletred             Hash = 0xa8b0f // mediumvioletred
	Midnightblue                Hash = 0xaa90c // midnightblue
	Min                         Hash = 0x14d03 // min
	Min_Height                  Hash = 0xab50a // min-height
	Min_Width                   Hash = 0xabf09 // min-width
	Mintcream                   Hash = 0xac809 // mintcream
	Mistyrose                   Hash = 0xae409 // mistyrose
	Mm                          Hash = 0xaed02 // mm
	Moccasin                    Hash = 0xb0308 // moccasin
	Monospace                   Hash = 0xaa009 // monospace
	Ms                          Hash = 0x102   // ms
	Namespace                   Hash = 0xd409  // namespace
	Navajowhite                 Hash = 0x750b  // navajowhite
	No_Repeat                   Hash = 0xbf09  // no-repeat
	None                        Hash = 0x38e04 // none
	Normal                      Hash = 0x36e06 // normal
	Offset                      Hash = 0xad706 // offset
	Offset_Anchor               Hash = 0xad70d // offset-anchor
	Offset_Distance             Hash = 0xb1d0f // offset-distance
	Offset_Path                 Hash = 0xb2c0b // offset-path
	Offset_Position             Hash = 0xb370f // offset-position
	Offset_Rotate               Hash = 0xb460d // offset-rotate
	Olivedrab                   Hash = 0xb6609 // olivedrab
	Orangered                   Hash = 0x75409 // orangered
	Order                       Hash = 0x22805 // order
	Orphans                     Hash = 0x37f07 // orphans
	Outline                     Hash = 0xba707 // outline
	Outline_Color               Hash = 0xba70d // outline-color
	Outline_Style               Hash = 0xbb40d // outline-style
	Outline_Width               Hash = 0xbc10d // outline-width
	Overflow                    Hash = 0x9d08  // overflow
	Overflow_X                  Hash = 0x9d0a  // overflow-x
	Overflow_Y                  Hash = 0xbce0a // overflow-y
	Padding                     Hash = 0x45207 // padding
	Padding_Bottom              Hash = 0xb7c0e // padding-bottom
	Padding_Box                 Hash = 0x4520b // padding-box
	Padding_Left                Hash = 0xd0a0c // padding-left
	Padding_Right               Hash = 0x5420d // padding-right
	Padding_Top                 Hash = 0x57b0b // padding-top
	Page                        Hash = 0x58504 // page
	Page_Break_After            Hash = 0x58510 // page-break-after
	Page_Break_Before           Hash = 0x6ac11 // page-break-before
	Page_Break_Inside           Hash = 0x6f211 // page-break-inside
	Palegoldenrod               Hash = 0xc100d // palegoldenrod
	Palegreen                   Hash = 0xbd809 // palegreen
	Paleturquoise               Hash = 0xbe10d // paleturquoise
	Palevioletred               Hash = 0xbee0d // palevioletred
	Papayawhip                  Hash = 0xc070a // papayawhip
	Pause                       Hash = 0xc2905 // pause
	Pause_After                 Hash = 0xc290b // pause-after
	Pause_Before                Hash = 0xc340c // pause-before
	Pc                          Hash = 0x53702 // pc
	Peachpuff                   Hash = 0x89509 // peachpuff
	Pitch                       Hash = 0x55005 // pitch
	Pitch_Range                 Hash = 0x5500b // pitch-range
	Place_Content               Hash = 0xc400d // place-content
	Place_Items                 Hash = 0xc4d0b // place-items
	Place_Self                  Hash = 0xc7e0a // place-self
	Play_During                 Hash = 0xcd10b // play-during
	Position                    Hash = 0x13908 // position
	Powderblue                  Hash = 0xc9b0a // powderblue
	Progid                      Hash = 0xca506 // progid
	Pt                          Hash = 0x39302 // pt
	Px                          Hash = 0x55d02 // px
	Q                           Hash = 0x64d01 // q
	Quotes                      Hash = 0xcb706 // quotes
	Rad                         Hash = 0x903   // rad
	Radial_Gradient             Hash = 0x90f   // radial-gradient
	Repeat                      Hash = 0xc206  // repeat
	Repeat_X                    Hash = 0x1c308 // repeat-x
	Repeat_Y                    Hash = 0xc208  // repeat-y
	Rgb                         Hash = 0x2903  // rgb
	Rgba                        Hash = 0x2904  // rgba
	Richness                    Hash = 0xae08  // richness
	Right                       Hash = 0x31905 // right
	Rosybrown                   Hash = 0xf309  // rosybrown
	Round                       Hash = 0x3005  // round
	Row_Gap                     Hash = 0x6ec07 // row-gap
	Royalblue                   Hash = 0x69509 // royalblue
	Ruby_Align                  Hash = 0xd930a // ruby-align
	Ruby_Overhang               Hash = 0xe00d  // ruby-overhang
	Ruby_Position               Hash = 0x1340d // ruby-position
	S                           Hash = 0x201   // s
	Saddlebrown                 Hash = 0xb50b  // saddlebrown
	Sandybrown                  Hash = 0x3850a // sandybrown
	Sans_Serif                  Hash = 0x39b0a // sans-serif
	Scroll                      Hash = 0x12006 // scroll
	Scrollbar_3d_Light_Color    Hash = 0xd7c18 // scrollbar-3d-light-color
	Scrollbar_Arrow_Color       Hash = 0x12015 // scrollbar-arrow-color
	Scrollbar_Base_Color        Hash = 0x8a614 // scrollbar-base-color
	Scrollbar_Dark_Shadow_Color Hash = 0x5d31b // scrollbar-dark-shadow-color
	Scrollbar_Face_Color        Hash = 0x61114 // scrollbar-face-color
	Scrollbar_Highlight_Color   Hash = 0x7cb19 // scrollbar-highlight-color
	Scrollbar_Shadow_Color      Hash = 0x87116 // scrollbar-shadow-color
	Scrollbar_Track_Color       Hash = 0x72315 // scrollbar-track-color
	Seagreen                    Hash = 0x93c08 // seagreen
	Seashell                    Hash = 0x2c308 // seashell
	Serif                       Hash = 0x3a005 // serif
	Size                        Hash = 0x1d604 // size
	Slateblue                   Hash = 0x95509 // slateblue
	Slategray                   Hash = 0xbfe09 // slategray
	Small                       Hash = 0x68f05 // small
	Smaller                     Hash = 0x68f07 // smaller
	Solid                       Hash = 0x74c05 // solid
	Space                       Hash = 0x6905  // space
	Speak                       Hash = 0x78105 // speak
	Speak_Header                Hash = 0x7810c // speak-header
	Speak_Numeral               Hash = 0x7f90d // speak-numeral
	Speak_Punctuation           Hash = 0xaf211 // speak-punctuation
	Speech_Rate                 Hash = 0xc570b // speech-rate
	Springgreen                 Hash = 0xa710b // springgreen
	Steelblue                   Hash = 0x96309 // steelblue
	Stress                      Hash = 0x11b06 // stress
	Stroke                      Hash = 0xc7806 // stroke
	Supports                    Hash = 0xcbc08 // supports
	Table_Layout                Hash = 0xcf20c // table-layout
	Text_Align                  Hash = 0x10e0a // text-align
	Text_Align_Last             Hash = 0x10e0f // text-align-last
	Text_Autospace              Hash = 0x4400e // text-autospace
	Text_Decoration             Hash = 0x7e0f  // text-decoration
	Text_Decoration_Color       Hash = 0x2a115 // text-decoration-color
	Text_Decoration_Line        Hash = 0x7e14  // text-decoration-line
	Text_Decoration_Style       Hash = 0xb5115 // text-decoration-style
	Text_Decoration_Thickness   Hash = 0xc6019 // text-decoration-thickness
	Text_Emphasis               Hash = 0x170d  // text-emphasis
	Text_Emphasis_Color         Hash = 0x1713  // text-emphasis-color
	Text_Indent                 Hash = 0x3f0b  // text-indent
	Text_Justify                Hash = 0x490c  // text-justify
	Text_Kashida_Space          Hash = 0x5c12  // text-kashida-space
	Text_Overflow               Hash = 0x980d  // text-overflow
	Text_Shadow                 Hash = 0xd6d0b // text-shadow
	Text_Transform              Hash = 0xda40e // text-transform
	Text_Underline_Position     Hash = 0xdc717 // text-underline-position
	Top                         Hash = 0x3be03 // top
	Transition                  Hash = 0x4750a // transition
	Transition_Delay            Hash = 0x59a10 // transition-delay
	Transition_Duration         Hash = 0xb9413 // transition-duration
	Transition_Property         Hash = 0x47513 // transition-property
	Transition_Timing_Function  Hash = 0xa281a // transition-timing-function
	Transparent                 Hash = 0xd150b // transparent
	Turn                        Hash = 0xd1f04 // turn
	Turquoise                   Hash = 0xa8209 // turquoise
	Unicode_Bidi                Hash = 0xcc40c // unicode-bidi
	Unicode_Range               Hash = 0xd230d // unicode-range
	Unset                       Hash = 0xd3005 // unset
	Url                         Hash = 0x3f403 // url
	Var                         Hash = 0x64503 // var
	Vertical_Align              Hash = 0x7e60e // vertical-align
	Visibility                  Hash = 0x4f70a // visibility
	Voice_Family                Hash = 0xd350c // voice-family
	Volume                      Hash = 0xd4106 // volume
	White                       Hash = 0x7b05  // white
	White_Space                 Hash = 0x6500b // white-space
	Whitesmoke                  Hash = 0x5c30a // whitesmoke
	Widows                      Hash = 0xd7706 // widows
	Width                       Hash = 0x26b05 // width
	Word_Break                  Hash = 0x1670a // word-break
	Word_Spacing                Hash = 0x28e0c // word-spacing
	Word_Wrap                   Hash = 0xd0209 // word-wrap
	Writing_Mode                Hash = 0xc8f0c // writing-mode
	X_Large                     Hash = 0xa707  // x-large
	X_Small                     Hash = 0x68d07 // x-small
	Xx_Large                    Hash = 0xa608  // xx-large
	Xx_Small                    Hash = 0x68c08 // xx-small
	Yellow                      Hash = 0x76506 // yellow
	Yellowgreen                 Hash = 0x7650b // yellowgreen
	Z_Index                     Hash = 0x68607 // z-index
)

//var HashMap = map[string]Hash{
//	"-ms-filter": Ms_Filter,
//	"accelerator": Accelerator,
//	"aliceblue": Aliceblue,
//	"align-content": Align_Content,
//	"align-items": Align_Items,
//	"align-self": Align_Self,
//	"all": All,
//	"alpha": Alpha,
//	"animation": Animation,
//	"animation-delay": Animation_Delay,
//	"animation-direction": Animation_Direction,
//	"animation-duration": Animation_Duration,
//	"animation-fill-mode": Animation_Fill_Mode,
//	"animation-iteration-count": Animation_Iteration_Count,
//	"animation-name": Animation_Name,
//	"animation-play-state": Animation_Play_State,
//	"animation-timing-function": Animation_Timing_Function,
//	"antiquewhite": Antiquewhite,
//	"aquamarine": Aquamarine,
//	"attr": Attr,
//	"auto": Auto,
//	"azimuth": Azimuth,
//	"background": Background,
//	"background-attachment": Background_Attachment,
//	"background-clip": Background_Clip,
//	"background-color": Background_Color,
//	"background-image": Background_Image,
//	"background-origin": Background_Origin,
//	"background-position": Background_Position,
//	"background-position-x": Background_Position_X,
//	"background-position-y": Background_Position_Y,
//	"background-repeat": Background_Repeat,
//	"background-size": Background_Size,
//	"behavior": Behavior,
//	"black": Black,
//	"blanchedalmond": Blanchedalmond,
//	"blueviolet": Blueviolet,
//	"bold": Bold,
//	"border": Border,
//	"border-bottom": Border_Bottom,
//	"border-bottom-color": Border_Bottom_Color,
//	"border-bottom-style": Border_Bottom_Style,
//	"border-bottom-width": Border_Bottom_Width,
//	"border-box": Border_Box,
//	"border-collapse": Border_Collapse,
//	"border-color": Border_Color,
//	"border-left": Border_Left,
//	"border-left-color": Border_Left_Color,
//	"border-left-style": Border_Left_Style,
//	"border-left-width": Border_Left_Width,
//	"border-right": Border_Right,
//	"border-right-color": Border_Right_Color,
//	"border-right-style": Border_Right_Style,
//	"border-right-width": Border_Right_Width,
//	"border-spacing": Border_Spacing,
//	"border-style": Border_Style,
//	"border-top": Border_Top,
//	"border-top-color": Border_Top_Color,
//	"border-top-style": Border_Top_Style,
//	"border-top-width": Border_Top_Width,
//	"border-width": Border_Width,
//	"bottom": Bottom,
//	"box-shadow": Box_Shadow,
//	"burlywood": Burlywood,
//	"cadetblue": Cadetblue,
//	"calc": Calc,
//	"caption-side": Caption_Side,
//	"caret-color": Caret_Color,
//	"center": Center,
//	"charset": Charset,
//	"chartreuse": Chartreuse,
//	"chocolate": Chocolate,
//	"clamp": Clamp,
//	"clear": Clear,
//	"clip": Clip,
//	"cm": Cm,
//	"color": Color,
//	"column-count": Column_Count,
//	"column-gap": Column_Gap,
//	"column-rule": Column_Rule,
//	"column-rule-color": Column_Rule_Color,
//	"column-rule-style": Column_Rule_Style,
//	"column-rule-width": Column_Rule_Width,
//	"column-width": Column_Width,
//	"columns": Columns,
//	"content": Content,
//	"cornflowerblue": Cornflowerblue,
//	"cornsilk": Cornsilk,
//	"counter-increment": Counter_Increment,
//	"counter-reset": Counter_Reset,
//	"cue": Cue,
//	"cue-after": Cue_After,
//	"cue-before": Cue_Before,
//	"currentcolor": Currentcolor,
//	"cursive": Cursive,
//	"cursor": Cursor,
//	"darkblue": Darkblue,
//	"darkcyan": Darkcyan,
//	"darkgoldenrod": Darkgoldenrod,
//	"darkgray": Darkgray,
//	"darkgreen": Darkgreen,
//	"darkkhaki": Darkkhaki,
//	"darkmagenta": Darkmagenta,
//	"darkolivegreen": Darkolivegreen,
//	"darkorange": Darkorange,
//	"darkorchid": Darkorchid,
//	"darksalmon": Darksalmon,
//	"darkseagreen": Darkseagreen,
//	"darkslateblue": Darkslateblue,
//	"darkslategray": Darkslategray,
//	"darkturquoise": Darkturquoise,
//	"darkviolet": Darkviolet,
//	"deeppink": Deeppink,
//	"deepskyblue": Deepskyblue,
//	"default": Default,
//	"deg": Deg,
//	"direction": Direction,
//	"display": Display,
//	"document": Document,
//	"dodgerblue": Dodgerblue,
//	"dpcm": Dpcm,
//	"dpi": Dpi,
//	"dppx": Dppx,
//	"elevation": Elevation,
//	"empty-cells": Empty_Cells,
//	"env": Env,
//	"fantasy": Fantasy,
//	"fill": Fill,
//	"filter": Filter,
//	"firebrick": Firebrick,
//	"flex": Flex,
//	"flex-basis": Flex_Basis,
//	"flex-direction": Flex_Direction,
//	"flex-flow": Flex_Flow,
//	"flex-grow": Flex_Grow,
//	"flex-shrink": Flex_Shrink,
//	"flex-wrap": Flex_Wrap,
//	"float": Float,
//	"floralwhite": Floralwhite,
//	"font": Font,
//	"font-face": Font_Face,
//	"font-family": Font_Family,
//	"font-size": Font_Size,
//	"font-size-adjust": Font_Size_Adjust,
//	"font-stretch": Font_Stretch,
//	"font-style": Font_Style,
//	"font-variant": Font_Variant,
//	"font-weight": Font_Weight,
//	"forestgreen": Forestgreen,
//	"fuchsia": Fuchsia,
//	"function": Function,
//	"gainsboro": Gainsboro,
//	"ghostwhite": Ghostwhite,
//	"goldenrod": Goldenrod,
//	"grad": Grad,
//	"greenyellow": Greenyellow,
//	"grid": Grid,
//	"grid-area": Grid_Area,
//	"grid-auto-columns": Grid_Auto_Columns,
//	"grid-auto-flow": Grid_Auto_Flow,
//	"grid-auto-rows": Grid_Auto_Rows,
//	"grid-column": Grid_Column,
//	"grid-column-end": Grid_Column_End,
//	"grid-column-gap": Grid_Column_Gap,
//	"grid-column-start": Grid_Column_Start,
//	"grid-row": Grid_Row,
//	"grid-row-end": Grid_Row_End,
//	"grid-row-gap": Grid_Row_Gap,
//	"grid-row-start": Grid_Row_Start,
//	"grid-template": Grid_Template,
//	"grid-template-areas": Grid_Template_Areas,
//	"grid-template-columns": Grid_Template_Columns,
//	"grid-template-rows": Grid_Template_Rows,
//	"height": Height,
//	"honeydew": Honeydew,
//	"hsl": Hsl,
//	"hsla": Hsla,
//	"hz": Hz,
//	"ime-mode": Ime_Mode,
//	"import": Import,
//	"important": Important,
//	"in": In,
//	"include-source": Include_Source,
//	"indianred": Indianred,
//	"inherit": Inherit,
//	"initial": Initial,
//	"invert": Invert,
//	"justify-content": Justify_Content,
//	"justify-items": Justify_Items,
//	"justify-self": Justify_Self,
//	"keyframes": Keyframes,
//	"khz": Khz,
//	"large": Large,
//	"larger": Larger,
//	"lavender": Lavender,
//	"lavenderblush": Lavenderblush,
//	"lawngreen": Lawngreen,
//	"layer-background-color": Layer_Background_Color,
//	"layer-background-image": Layer_Background_Image,
//	"layout-flow": Layout_Flow,
//	"layout-grid": Layout_Grid,
//	"layout-grid-char": Layout_Grid_Char,
//	"layout-grid-char-spacing": Layout_Grid_Char_Spacing,
//	"layout-grid-line": Layout_Grid_Line,
//	"layout-grid-mode": Layout_Grid_Mode,
//	"layout-grid-type": Layout_Grid_Type,
//	"left": Left,
//	"lemonchiffon": Lemonchiffon,
//	"letter-spacing": Letter_Spacing,
//	"lightblue": Lightblue,
//	"lightcoral": Lightcoral,
//	"lightcyan": Lightcyan,
//	"lightgoldenrodyellow": Lightgoldenrodyellow,
//	"lightgray": Lightgray,
//	"lightgreen": Lightgreen,
//	"lightpink": Lightpink,
//	"lightsalmon": Lightsalmon,
//	"lightseagreen": Lightseagreen,
//	"lightskyblue": Lightskyblue,
//	"lightslateblue": Lightslateblue,
//	"lightsteelblue": Lightsteelblue,
//	"lightyellow": Lightyellow,
//	"limegreen": Limegreen,
//	"line-break": Line_Break,
//	"line-height": Line_Height,
//	"linear-gradient": Linear_Gradient,
//	"list-style": List_Style,
//	"list-style-image": List_Style_Image,
//	"list-style-position": List_Style_Position,
//	"list-style-type": List_Style_Type,
//	"local": Local,
//	"magenta": Magenta,
//	"margin": Margin,
//	"margin-bottom": Margin_Bottom,
//	"margin-left": Margin_Left,
//	"margin-right": Margin_Right,
//	"margin-top": Margin_Top,
//	"marker-offset": Marker_Offset,
//	"marks": Marks,
//	"mask": Mask,
//	"max": Max,
//	"max-height": Max_Height,
//	"max-width": Max_Width,
//	"media": Media,
//	"medium": Medium,
//	"mediumaquamarine": Mediumaquamarine,
//	"mediumblue": Mediumblue,
//	"mediumorchid": Mediumorchid,
//	"mediumpurple": Mediumpurple,
//	"mediumseagreen": Mediumseagreen,
//	"mediumslateblue": Mediumslateblue,
//	"mediumspringgreen": Mediumspringgreen,
//	"mediumturquoise": Mediumturquoise,
//	"mediumvioletred": Mediumvioletred,
//	"midnightblue": Midnightblue,
//	"min": Min,
//	"min-height": Min_Height,
//	"min-width": Min_Width,
//	"mintcream": Mintcream,
//	"mistyrose": Mistyrose,
//	"mm": Mm,
//	"moccasin": Moccasin,
//	"monospace": Monospace,
//	"ms": Ms,
//	"namespace": Namespace,
//	"navajowhite": Navajowhite,
//	"no-repeat": No_Repeat,
//	"none": None,
//	"normal": Normal,
//	"offset": Offset,
//	"offset-anchor": Offset_Anchor,
//	"offset-distance": Offset_Distance,
//	"offset-path": Offset_Path,
//	"offset-position": Offset_Position,
//	"offset-rotate": Offset_Rotate,
//	"olivedrab": Olivedrab,
//	"orangered": Orangered,
//	"order": Order,
//	"orphans": Orphans,
//	"outline": Outline,
//	"outline-color": Outline_Color,
//	"outline-style": Outline_Style,
//	"outline-width": Outline_Width,
//	"overflow": Overflow,
//	"overflow-x": Overflow_X,
//	"overflow-y": Overflow_Y,
//	"padding": Padding,
//	"padding-bottom": Padding_Bottom,
//	"padding-box": Padding_Box,
//	"padding-left": Padding_Left,
//	"padding-right": Padding_Right,
//	"padding-top": Padding_Top,
//	"page": Page,
//	"page-break-after": Page_Break_After,
//	"page-break-before": Page_Break_Before,
//	"page-break-inside": Page_Break_Inside,
//	"palegoldenrod": Palegoldenrod,
//	"palegreen": Palegreen,
//	"paleturquoise": Paleturquoise,
//	"palevioletred": Palevioletred,
//	"papayawhip": Papayawhip,
//	"pause": Pause,
//	"pause-after": Pause_After,
//	"pause-before": Pause_Before,
//	"pc": Pc,
//	"peachpuff": Peachpuff,
//	"pitch": Pitch,
//	"pitch-range": Pitch_Range,
//	"place-content": Place_Content,
//	"place-items": Place_Items,
//	"place-self": Place_Self,
//	"play-during": Play_During,
//	"position": Position,
//	"powderblue": Powderblue,
//	"progid": Progid,
//	"pt": Pt,
//	"px": Px,
//	"q": Q,
//	"quotes": Quotes,
//	"rad": Rad,
//	"radial-gradient": Radial_Gradient,
//	"repeat": Repeat,
//	"repeat-x": Repeat_X,
//	"repeat-y": Repeat_Y,
//	"rgb": Rgb,
//	"rgba": Rgba,
//	"richness": Richness,
//	"right": Right,
//	"rosybrown": Rosybrown,
//	"round": Round,
//	"row-gap": Row_Gap,
//	"royalblue": Royalblue,
//	"ruby-align": Ruby_Align,
//	"ruby-overhang": Ruby_Overhang,
//	"ruby-position": Ruby_Position,
//	"s": S,
//	"saddlebrown": Saddlebrown,
//	"sandybrown": Sandybrown,
//	"sans-serif": Sans_Serif,
//	"scroll": Scroll,
//	"scrollbar-3d-light-color": Scrollbar_3d_Light_Color,
//	"scrollbar-arrow-color": Scrollbar_Arrow_Color,
//	"scrollbar-base-color": Scrollbar_Base_Color,
//	"scrollbar-dark-shadow-color": Scrollbar_Dark_Shadow_Color,
//	"scrollbar-face-color": Scrollbar_Face_Color,
//	"scrollbar-highlight-color": Scrollbar_Highlight_Color,
//	"scrollbar-shadow-color": Scrollbar_Shadow_Color,
//	"scrollbar-track-color": Scrollbar_Track_Color,
//	"seagreen": Seagreen,
//	"seashell": Seashell,
//	"serif": Serif,
//	"size": Size,
//	"slateblue": Slateblue,
//	"slategray": Slategray,
//	"small": Small,
//	"smaller": Smaller,
//	"solid": Solid,
//	"space": Space,
//	"speak": Speak,
//	"speak-header": Speak_Header,
//	"speak-numeral": Speak_Numeral,
//	"speak-punctuation": Speak_Punctuation,
//	"speech-rate": Speech_Rate,
//	"springgreen": Springgreen,
//	"steelblue": Steelblue,
//	"stress": Stress,
//	"stroke": Stroke,
//	"supports": Supports,
//	"table-layout": Table_Layout,
//	"text-align": Text_Align,
//	"text-align-last": Text_Align_Last,
//	"text-autospace": Text_Autospace,
//	"text-decoration": Text_Decoration,
//	"text-decoration-color": Text_Decoration_Color,
//	"text-decoration-line": Text_Decoration_Line,
//	"text-decoration-style": Text_Decoration_Style,
//	"text-decoration-thickness": Text_Decoration_Thickness,
//	"text-emphasis": Text_Emphasis,
//	"text-emphasis-color": Text_Emphasis_Color,
//	"text-indent": Text_Indent,
//	"text-justify": Text_Justify,
//	"text-kashida-space": Text_Kashida_Space,
//	"text-overflow": Text_Overflow,
//	"text-shadow": Text_Shadow,
//	"text-transform": Text_Transform,
//	"text-underline-position": Text_Underline_Position,
//	"top": Top,
//	"transition": Transition,
//	"transition-delay": Transition_Delay,
//	"transition-duration": Transition_Duration,
//	"transition-property": Transition_Property,
//	"transition-timing-function": Transition_Timing_Function,
//	"transparent": Transparent,
//	"turn": Turn,
//	"turquoise": Turquoise,
//	"unicode-bidi": Unicode_Bidi,
//	"unicode-range": UnicodeRange,
//	"unset": Unset,
//	"url": Url,
//	"var": Var,
//	"vertical-align": Vertical_Align,
//	"visibility": Visibility,
//	"voice-family": Voice_Family,
//	"volume": Volume,
//	"white": White,
//	"white-space": White_Space,
//	"whitesmoke": Whitesmoke,
//	"widows": Widows,
//	"width": Width,
//	"word-break": Word_Break,
//	"word-spacing": Word_Spacing,
//	"word-wrap": Word_Wrap,
//	"writing-mode": Writing_Mode,
//	"x-large": X_Large,
//	"x-small": X_Small,
//	"xx-large": Xx_Large,
//	"xx-small": Xx_Small,
//	"yellow": Yellow,
//	"yellowgreen": Yellowgreen,
//	"z-index": Z_Index,
//}

// String returns the text associated with the hash.
func (i Hash) String() string {
	return string(i.Bytes())
}

// Bytes returns the text associated with the hash.
func (i Hash) Bytes() []byte {
	start := uint32(i >> 8)
	n := uint32(i & 0xff)
	if start+n > uint32(len(_Hash_text)) {
		return []byte{}
	}
	return _Hash_text[start : start+n]
}

// ToHash returns a hash Hash for a given []byte. Hash is a uint32 that is associated with the text in []byte. It returns zero if no match found.
func ToHash(s []byte) Hash {
	if len(s) == 0 || len(s) > _Hash_maxLen {
		return 0
	}
	//if 3 < len(s) {
	//	return HashMap[string(s)]
	//}
	h := uint32(_Hash_hash0)
	for i := 0; i < len(s); i++ {
		h ^= uint32(s[i])
		h *= 16777619
	}
	if i := _Hash_table[h&uint32(len(_Hash_table)-1)]; int(i&0xff) == len(s) {
		t := _Hash_text[i>>8 : i>>8+i&0xff]
		for i := 0; i < len(s); i++ {
			if t[i] != s[i] {
				goto NEXT
			}
		}
		return i
	}
NEXT:
	if i := _Hash_table[(h>>16)&uint32(len(_Hash_table)-1)]; int(i&0xff) == len(s) {
		t := _Hash_text[i>>8 : i>>8+i&0xff]
		for i := 0; i < len(s); i++ {
			if t[i] != s[i] {
				return 0
			}
		}
		return i
	}
	return 0
}

const _Hash_hash0 = 0x9acb0442
const _Hash_maxLen = 27

var _Hash_text = []byte("" +
	"-ms-filteradial-gradientext-emphasis-colorgbackground-attach" +
	"mentext-indentext-justify-contentext-kashida-spacelevationav" +
	"ajowhitext-decoration-line-heightext-overflow-xx-largerichne" +
	"ssaddlebrowno-repeat-yanimation-namespacenteruby-overhangain" +
	"sborosybrownanimation-play-statext-align-lastresscrollbar-ar" +
	"row-coloruby-positionanimation-timing-functionazimuthoneydew" +
	"ord-breakbackground-originclude-sourcebackground-position-xb" +
	"ackground-position-ybackground-repeat-xbackground-sizebehavi" +
	"orblackblanchedalmondarkblueboldarkcyanimation-delayer-backg" +
	"round-colorborder-bottom-colorborder-bottom-stylemonchiffont" +
	"-faceborder-bottom-widthslavenderblushborder-box-shadoword-s" +
	"pacinghostwhitext-decoration-colorborder-collapseashellawngr" +
	"eenborder-colorborder-left-colorborder-left-styleborder-left" +
	"-widthborder-right-colorborder-right-styleborder-right-width" +
	"border-spacingrid-areanimation-durationormalphacceleratorpha" +
	"nsandybrownonempty-cellsans-serifantasyborder-styleborder-to" +
	"p-colorborder-top-styleborder-top-widthborder-widthburlywood" +
	"arkgoldenrodarkgraycaption-sideepskybluecaret-colorchartreus" +
	"echocolatext-autospaceclampadding-boxclearcolumn-counter-res" +
	"etransition-propertycolumn-rule-colorcolumn-rule-stylecolumn" +
	"-rule-widthcolumn-widthcornflowerbluecornsilkcue-aftercue-be" +
	"forestgreenvisibilitycurrentcolorcursivecursordarkvioletdocu" +
	"mentdodgerbluedpcmargin-topadding-rightdpitch-rangedppxflex-" +
	"growflex-shrinkflex-wrapadding-topage-break-afterfloattransi" +
	"tion-delayer-background-imagefloralwhitesmokeyframescrollbar" +
	"-dark-shadow-colorfont-familyfont-size-adjustify-itemscrollb" +
	"ar-face-colorfont-stretcharsetfont-stylefont-variantiquewhit" +
	"e-spacefont-weightfuchsianimation-fill-modeeppinkhz-indexx-s" +
	"malleroyalbluegrid-column-gapage-break-beforegrid-column-sta" +
	"rtgrid-row-endarkolivegreengrid-row-gapage-break-insidegrid-" +
	"row-startgrid-template-areascrollbar-track-colorgrid-templat" +
	"e-columnsolidarkorangeredarkgreenyellowgreengrid-template-ro" +
	"wspeak-headerimportantinheritinitialicebluevioletter-spacing" +
	"rid-auto-columnscrollbar-highlight-colorinvertical-align-ite" +
	"mspeak-numeralayout-grid-char-spacingrid-auto-flowjustify-se" +
	"lfirebricklayout-grid-line-breaklayout-grid-modegrid-auto-ro" +
	"wscrollbar-shadow-colorlayout-grid-typeachpufflex-basiscroll" +
	"bar-base-colorlightbluelightcoralign-selflex-directionlightc" +
	"yanimation-directionlightgoldenrodyellowlightgraylightgreenl" +
	"ightpinklightsalmonlightseagreenlightskybluelightslateblueli" +
	"ghtsteelbluelightyellowlimegreenlinear-gradientlist-style-im" +
	"agelist-style-positionlist-style-typelocalcadetbluemaskmax-h" +
	"eightmax-widthmediumaquamarinemediumbluemediumorchidarkorchi" +
	"darkkhakime-modefaultransition-timing-functionmediumpurpleme" +
	"diumseagreenmediumslatebluemediumspringgreenmediumturquoisem" +
	"ediumvioletredarksalmonospacemidnightbluemin-heightmin-width" +
	"mintcreamarker-offset-anchormistyrosemmarkspeak-punctuationm" +
	"occasindianredarkseagreenoffset-distanceoffset-pathoffset-po" +
	"sitionoffset-rotatext-decoration-styleolivedrabackground-cli" +
	"padding-bottomargin-rightransition-durationoutline-coloroutl" +
	"ine-styleoutline-widthoverflow-ypalegreenpaleturquoisepalevi" +
	"oletredarkslategraypapayawhipalegoldenrodarkslatebluepause-a" +
	"fterpause-beforeplace-contentplace-itemspeech-ratext-decorat" +
	"ion-thicknesstrokeplace-selflex-flowriting-modepowderbluepro" +
	"gidarkturquoisequotesupportsunicode-bidisplay-duringrid-colu" +
	"mn-endarkmagentable-layout-floword-wrapadding-leftransparent" +
	"urnunicode-rangeunsetvoice-familyvolumedianimation-iteration" +
	"-counter-incrementext-shadowidowscrollbar-3d-light-coloruby-" +
	"align-contentext-transformargin-bottomargin-leftext-underlin" +
	"e-position")

var _Hash_table = [1 << 10]Hash{
	0x3:   0xc290b, // pause-after
	0x6:   0xd5d11, // counter-increment
	0x8:   0xcce07, // display
	0x9:   0x51a0a, // darkviolet
	0xb:   0xbf09,  // no-repeat
	0xd:   0x4402,  // in
	0x14:  0x6f211, // page-break-inside
	0x15:  0x6250c, // font-stretch
	0x19:  0x5f910, // font-size-adjust
	0x1a:  0x47513, // transition-property
	0x1c:  0x78105, // speak
	0x1f:  0x82a0c, // justify-self
	0x20:  0x61114, // scrollbar-face-color
	0x24:  0x2b60f, // border-collapse
	0x25:  0x68607, // z-index
	0x27:  0xd980d, // align-content
	0x2a:  0x99f13, // list-style-position
	0x2b:  0xcdb0f, // grid-column-end
	0x2c:  0x14119, // animation-timing-function
	0x30:  0xb0909, // indianred
	0x34:  0x97709, // limegreen
	0x35:  0xbc10d, // outline-width
	0x3f:  0x15a07, // azimuth
	0x40:  0x1e70e, // blanchedalmond
	0x41:  0x84a0a, // line-break
	0x42:  0x7a209, // aliceblue
	0x43:  0xf309,  // rosybrown
	0x46:  0xa7c0f, // mediumturquoise
	0x49:  0xd7706, // widows
	0x4b:  0xb370f, // offset-position
	0x4d:  0xd150b, // transparent
	0x4e:  0x79d07, // initial
	0x52:  0x1cb0f, // background-size
	0x55:  0x2505,  // color
	0x56:  0x59a10, // transition-delay
	0x5a:  0x750b,  // navajowhite
	0x5b:  0x7110d, // grid-template
	0x5c:  0x3b710, // border-top-color
	0x62:  0xbce0a, // overflow-y
	0x64:  0x9370d, // lightseagreen
	0x6c:  0x10e0f, // text-align-last
	0x6f:  0x8050b, // layout-grid
	0x70:  0xca09,  // animation
	0x71:  0x1da08, // behavior
	0x72:  0x5390a, // margin-top
	0x74:  0x3ab0c, // border-style
	0x78:  0x5d31b, // scrollbar-dark-shadow-color
	0x79:  0x69103, // all
	0x7a:  0x3f0b,  // text-indent
	0x7b:  0xbe10d, // paleturquoise
	0x7e:  0x58510, // page-break-after
	0x80:  0x5420d, // padding-right
	0x84:  0x7e60e, // vertical-align
	0x85:  0x50d07, // cursive
	0x8a:  0x7030e, // grid-row-start
	0x8c:  0xae08,  // richness
	0x8e:  0x3b70a, // border-top
	0x94:  0x35509, // grid-area
	0x95:  0x85410, // layout-grid-mode
	0x96:  0xaee05, // marks
	0x97:  0x64d01, // q
	0x98:  0x78d09, // important
	0x9c:  0x406,   // filter
	0x9d:  0xa8b0f, // mediumvioletred
	0xa5:  0xc570b, // speech-rate
	0xa8:  0x53702, // pc
	0xab:  0x90f,   // radial-gradient
	0xae:  0x11b06, // stress
	0xb4:  0x6050d, // justify-items
	0xb7:  0x9500e, // lightslateblue
	0xba:  0x35504, // grid
	0xbb:  0xb0308, // moccasin
	0xbe:  0xd0209, // word-wrap
	0xc0:  0x6d90e, // darkolivegreen
	0xc5:  0xc6019, // text-decoration-thickness
	0xc7:  0xdb06,  // center
	0xc8:  0x2a115, // text-decoration-color
	0xcb:  0xabf09, // min-width
	0xce:  0x5ee0b, // font-family
	0xd1:  0xa1c08, // ime-mode
	0xd3:  0x3d710, // border-top-width
	0xd4:  0x53906, // margin
	0xd9:  0x4880b, // column-rule
	0xda:  0x98f0a, // list-style
	0xdf:  0x6ce0c, // grid-row-end
	0xe4:  0x2050f, // animation-delay
	0xe8:  0x4aa11, // column-rule-width
	0xec:  0x57309, // flex-wrap
	0xed:  0xced07, // magenta
	0xee:  0x88710, // layout-grid-type
	0xef:  0x4520b, // padding-box
	0xf0:  0x7e14,  // text-decoration-line
	0xf2:  0x4dd09, // cue-after
	0xf4:  0x8640e, // grid-auto-rows
	0xf5:  0x7650b, // yellowgreen
	0xf8:  0x89509, // peachpuff
	0xf9:  0x74607, // columns
	0xfa:  0x22805, // order
	0xfb:  0x3120c, // border-right
	0x100: 0x1800e, // include-source
	0x104: 0xc2905, // pause
	0x105: 0x1fc04, // bold
	0x106: 0xcc40c, // unicode-bidi
	0x108: 0x67604, // fill
	0x109: 0x75c09, // darkgreen
	0x10b: 0x45d05, // clear
	0x10c: 0x67d08, // deeppink
	0x110: 0x8e913, // animation-direction
	0x112: 0x1b811, // background-repeat
	0x117: 0xca506, // progid
	0x11d: 0x8a614, // scrollbar-base-color
	0x11e: 0xa,     // -ms-filter
	0x11f: 0x2ca09, // lawngreen
	0x120: 0x51406, // cursor
	0x121: 0x44e05, // clamp
	0x123: 0x48811, // column-rule-color
	0x128: 0x40f0c, // caption-side
	0x12a: 0xc9b0a, // powderblue
	0x12b: 0xdc717, // text-underline-position
	0x12d: 0x72315, // scrollbar-track-color
	0x131: 0x81c0e, // grid-auto-flow
	0x132: 0x7810c, // speak-header
	0x133: 0x25409, // font-face
	0x136: 0xa710b, // springgreen
	0x13a: 0xc7e0a, // place-self
	0x13d: 0xc206,  // repeat
	0x13e: 0x9800f, // linear-gradient
	0x142: 0x5010c, // currentcolor
	0x145: 0xad706, // offset
	0x14a: 0x69e0f, // grid-column-gap
	0x14c: 0x6905,  // space
	0x14e: 0x39b0a, // sans-serif
	0x14f: 0x6360a, // font-style
	0x153: 0x66607, // fuchsia
	0x154: 0xb7904, // clip
	0x155: 0xae409, // mistyrose
	0x158: 0x9d08,  // overflow
	0x15d: 0xc7806, // stroke
	0x162: 0x80510, // layout-grid-char
	0x163: 0xa420c, // mediumpurple
	0x165: 0x4f503, // env
	0x168: 0x4690d, // counter-reset
	0x16b: 0x5cb09, // keyframes
	0x16f: 0x7b05,  // white
	0x172: 0x1004,  // grad
	0x174: 0xdb10d, // margin-bottom
	0x175: 0x31212, // border-right-color
	0x177: 0x25404, // font
	0x178: 0xc100d, // palegoldenrod
	0x179: 0x73815, // grid-template-columns
	0x17a: 0x7e0f,  // text-decoration
	0x17e: 0x89d0a, // flex-basis
	0x186: 0x7ef0b, // align-items
	0x189: 0x4bb0c, // column-width
	0x18a: 0x3c710, // border-top-style
	0x18b: 0x1d604, // size
	0x18c: 0xd4505, // media
	0x191: 0xb7c0e, // padding-bottom
	0x194: 0x2df11, // border-left-color
	0x195: 0x7a70a, // blueviolet
	0x198: 0x92c0b, // lightsalmon
	0x19d: 0x27108, // lavender
	0x19e: 0x5a716, // layer-background-image
	0x1a0: 0x6500b, // white-space
	0x1a3: 0xe00d,  // ruby-overhang
	0x1a4: 0x24b0c, // lemonchiffon
	0x1a5: 0x3be03, // top
	0x1a9: 0x2c308, // seashell
	0x1aa: 0x7ae0e, // letter-spacing
	0x1ac: 0x2b0a,  // background
	0x1af: 0x64503, // var
	0x1b0: 0xaed02, // mm
	0x1b6: 0x12015, // scrollbar-arrow-color
	0x1b8: 0xda40e, // text-transform
	0x1b9: 0x65b0b, // font-weight
	0x1ba: 0x53802, // cm
	0x1bb: 0x12006, // scroll
	0x1c0: 0x21710, // background-color
	0x1c1: 0x2710d, // lavenderblush
	0x1c6: 0xb5115, // text-decoration-style
	0x1c9: 0x79607, // inherit
	0x1cf: 0x2e604, // left
	0x1d0: 0x6490c, // antiquewhite
	0x1d4: 0xb6609, // olivedrab
	0x1da: 0x2990a, // ghostwhite
	0x1dd: 0x91009, // lightgray
	0x1e2: 0x26f04, // hsla
	0x1e3: 0x26f03, // hsl
	0x1e4: 0xbd809, // palegreen
	0x1e5: 0x4190b, // deepskyblue
	0x1e8: 0xac809, // mintcream
	0x1ea: 0x7e406, // invert
	0x1eb: 0x6400c, // font-variant
	0x1ec: 0x8fc14, // lightgoldenrodyellow
	0x1ee: 0x62f07, // charset
	0x1ef: 0xc8f0c, // writing-mode
	0x1f0: 0x5c30a, // whitesmoke
	0x1f5: 0x9d0a,  // overflow-x
	0x1f6: 0xaa90c, // midnightblue
	0x1f7: 0xcb706, // quotes
	0x1f8: 0x22706, // border
	0x1fa: 0x42f0a, // chartreuse
	0x1fc: 0xba707, // outline
	0x1fd: 0xa281a, // transition-timing-function
	0x1fe: 0xcbc08, // supports
	0x204: 0x1670a, // word-break
	0x205: 0xaa009, // monospace
	0x206: 0x2850a, // box-shadow
	0x209: 0x5680b, // flex-shrink
	0x20f: 0xd0a0c, // padding-left
	0x214: 0xc4d0b, // place-items
	0x216: 0xc070a, // papayawhip
	0x217: 0x17111, // background-origin
	0x218: 0x52408, // document
	0x219: 0x52c0a, // dodgerblue
	0x21c: 0x9440c, // lightskyblue
	0x21e: 0x6bd11, // grid-column-start
	0x221: 0x30111, // border-left-width
	0x224: 0x68c08, // xx-small
	0x226: 0x1f408, // darkblue
	0x229: 0x25d13, // border-bottom-width
	0x22a: 0x98f10, // list-style-image
	0x22d: 0x44504, // auto
	0x230: 0x1e205, // black
	0x231: 0xaf211, // speak-punctuation
	0x232: 0x13908, // position
	0x234: 0xc340c, // pause-before
	0x236: 0x95e0e, // lightsteelblue
	0x23a: 0xcd10b, // play-during
	0x23f: 0x83509, // firebrick
	0x249: 0x6ce08, // grid-row
	0x24a: 0x55d02, // px
	0x24c: 0x1a315, // background-position-y
	0x251: 0xd1f04, // turn
	0x256: 0xba70d, // outline-color
	0x257: 0x9c304, // calc
	0x258: 0xd4919, // animation-iteration-count
	0x259: 0xad70d, // offset-anchor
	0x25b: 0xa4e0e, // mediumseagreen
	0x25e: 0x4620c, // column-count
	0x263: 0x10e0a, // text-align
	0x266: 0x66c13, // animation-fill-mode
	0x267: 0x32412, // border-right-style
	0x268: 0xa707,  // x-large
	0x269: 0x8d40e, // flex-direction
	0x26a: 0x4f70a, // visibility
	0x26f: 0xb2c0b, // offset-path
	0x270: 0x27e0a, // border-box
	0x276: 0x70103, // deg
	0x278: 0x1713,  // text-emphasis-color
	0x27f: 0xc1c0d, // darkslateblue
	0x283: 0x55f09, // flex-grow
	0x285: 0x8e209, // lightcyan
	0x28a: 0x102,   // ms
	0x28d: 0xa906,  // larger
	0x28e: 0xa990a, // darksalmon
	0x292: 0x2f011, // border-left-style
	0x293: 0xa8209, // turquoise
	0x294: 0x3a407, // fantasy
	0x296: 0xec09,  // gainsboro
	0x297: 0x201,   // s
	0x298: 0x23a13, // border-bottom-style
	0x299: 0xce90b, // darkmagenta
	0x29b: 0xb50b,  // saddlebrown
	0x2a0: 0x59505, // float
	0x2a3: 0x6ec07, // row-gap
	0x2a5: 0xd4106, // volume
	0x2a6: 0xab50a, // min-height
	0x2a7: 0x77012, // grid-template-rows
	0x2a9: 0x3760b, // accelerator
	0x2b0: 0x68f05, // small
	0x2b1: 0x59804, // attr
	0x2b2: 0x28e0c, // word-spacing
	0x2b3: 0x35d12, // animation-duration
	0x2b5: 0x4dd03, // cue
	0x2b6: 0x95509, // slateblue
	0x2b8: 0x38e04, // none
	0x2b9: 0x6a30a, // column-gap
	0x2ba: 0x4e0f,  // justify-content
	0x2bb: 0x5607,  // content
	0x2bd: 0x54f03, // dpi
	0x2be: 0x87116, // scrollbar-shadow-color
	0x2bf: 0x78d06, // import
	0x2c0: 0xc8709, // flex-flow
	0x2c1: 0x69509, // royalblue
	0x2c3: 0x9c609, // cadetblue
	0x2c4: 0x490c,  // text-justify
	0x2cb: 0x8c30a, // lightcoral
	0x2cf: 0xb890c, // margin-right
	0x2d2: 0x76506, // yellow
	0x2d3: 0x26b05, // width
	0x2d6: 0x14d03, // min
	0x2da: 0x1340d, // ruby-position
	0x2dc: 0x40708, // darkgray
	0x2e2: 0x69e0b, // grid-column
	0x2e4: 0xa1409, // darkkhaki
	0x2e5: 0xc400d, // place-content
	0x2e7: 0xbee0d, // palevioletred
	0x2ea: 0x5bd0b, // floralwhite
	0x2eb: 0xc208,  // repeat-y
	0x2ee: 0x980d,  // text-overflow
	0x2f1: 0xca0e,  // animation-name
	0x2fb: 0x7cb19, // scrollbar-highlight-color
	0x2fe: 0x5500b, // pitch-range
	0x302: 0x3005,  // round
	0x305: 0x4c70e, // cornflowerblue
	0x307: 0x7f90d, // speak-numeral
	0x308: 0x9e606, // medium
	0x30a: 0x170d,  // text-emphasis
	0x30d: 0x9dd09, // max-width
	0x311: 0x36e06, // normal
	0x312: 0x68403, // khz
	0x315: 0x2903,  // rgb
	0x316: 0x8ba09, // lightblue
	0x317: 0x8d909, // direction
	0x31a: 0xd350c, // voice-family
	0x31c: 0x3480e, // border-spacing
	0x321: 0x6d09,  // elevation
	0x323: 0x1c308, // repeat-x
	0x324: 0x83e10, // layout-grid-line
	0x326: 0xa000c, // mediumorchid
	0x32b: 0xa6b11, // mediumspringgreen
	0x32d: 0xa905,  // large
	0x32e: 0xd930a, // ruby-align
	0x330: 0xbfa0d, // darkslategray
	0x332: 0x5c12,  // text-kashida-space
	0x334: 0xbb40d, // outline-style
	0x336: 0x3a005, // serif
	0x337: 0x4240b, // caret-color
	0x33a: 0x37205, // alpha
	0x33c: 0x71113, // grid-template-areas
	0x33d: 0x49911, // column-rule-style
	0x33f: 0xcf80b, // layout-flow
	0x340: 0x31905, // right
	0x341: 0x3e70c, // border-width
	0x343: 0xb6e0f, // background-clip
	0x344: 0xd230d, // unicode-range
	0x345: 0x74c05, // solid
	0x346: 0x2df0b, // border-left
	0x348: 0x9ec0a, // aquamarine
	0x349: 0x3850a, // sandybrown
	0x34a: 0x16008, // honeydew
	0x34b: 0x75409, // orangered
	0x34c: 0xb110c, // darkseagreen
	0x34d: 0x37f07, // orphans
	0x34e: 0x6e70c, // grid-row-gap
	0x351: 0x22e06, // bottom
	0x359: 0x9c105, // local
	0x35c: 0x8cb0a, // align-self
	0x35e: 0x33612, // border-right-width
	0x360: 0x2b15,  // background-attachment
	0x364: 0x9190a, // lightgreen
	0x366: 0x39302, // pt
	0x368: 0x4400e, // text-autospace
	0x36b: 0x3f403, // url
	0x36c: 0x68502, // hz
	0x371: 0x9306,  // height
	0x372: 0x5ad10, // background-image
	0x377: 0x903,   // rad
	0x37c: 0x21116, // layer-background-color
	0x37d: 0x1ff08, // darkcyan
	0x382: 0x18e13, // background-position
	0x384: 0x9d303, // max
	0x38c: 0xa608,  // xx-large
	0x38d: 0x3f309, // burlywood
	0x38f: 0xd7c18, // scrollbar-3d-light-color
	0x390: 0x3ff09, // goldenrod
	0x392: 0x92309, // lightpink
	0x393: 0x8e0b,  // line-height
	0x396: 0x22713, // border-bottom-color
	0x398: 0x80518, // layout-grid-char-spacing
	0x39c: 0x2904,  // rgba
	0x3a1: 0x9f60a, // mediumblue
	0x3a3: 0x9d30a, // max-height
	0x3a4: 0x7bb11, // grid-auto-columns
	0x3a5: 0xa0b0a, // darkorchid
	0x3a9: 0x7600b, // greenyellow
	0x3ae: 0x96c0b, // lightyellow
	0x3b1: 0x4750a, // transition
	0x3b3: 0x4e60a, // cue-before
	0x3b6: 0x15208, // function
	0x3b9: 0x96309, // steelblue
	0x3be: 0xa5c0f, // mediumslateblue
	0x3bf: 0xcaa0d, // darkturquoise
	0x3c0: 0x43909, // chocolate
	0x3c3: 0x5f909, // font-size
	0x3c5: 0x55f04, // flex
	0x3c7: 0xd3005, // unset
	0x3c8: 0xd6d0b, // text-shadow
	0x3ca: 0x4ec0b, // forestgreen
	0x3cc: 0xbfe09, // slategray
	0x3cd: 0x6ac11, // page-break-before
	0x3ce: 0x55b04, // dppx
	0x3d0: 0x2270d, // border-bottom
	0x3d3: 0xb1d0f, // offset-distance
	0x3d4: 0x3fb0d, // darkgoldenrod
	0x3d6: 0x53604, // dpcm
	0x3d8: 0x7500a, // darkorange
	0x3dc: 0xb9413, // transition-duration
	0x3de: 0x2d30c, // border-color
	0x3df: 0x18e15, // background-position-x
	0x3e0: 0x55005, // pitch
	0x3e2: 0xdbd0b, // margin-left
	0x3e3: 0x58504, // page
	0x3e5: 0x57b0b, // padding-top
	0x3e7: 0xb460d, // offset-rotate
	0x3e8: 0x93c08, // seagreen
	0x3e9: 0x4d508, // cornsilk
	0x3ea: 0x68f07, // smaller
	0x3ec: 0xcf20c, // table-layout
	0x3ed: 0xfc14,  // animation-play-state
	0x3ef: 0xa2207, // default
	0x3f0: 0x68d07, // x-small
	0x3f3: 0x9e610, // mediumaquamarine
	0x3f4: 0xad00d, // marker-offset
	0x3f9: 0xd409,  // namespace
	0x3fa: 0x9cf04, // mask
	0x3fb: 0x45207, // padding
	0x3fd: 0x9b20f, // list-style-type
	0x3ff: 0x3910b, // empty-cells
}
