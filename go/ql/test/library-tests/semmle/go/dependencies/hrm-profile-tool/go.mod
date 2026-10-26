module github.com/clj/hrm-profile-tool

require (
	github.com/ajstarks/svgo v0.0.0-20180830174826-7338bd80e790
	github.com/clj/hrm-profile-tool/cmd/hrm v0.0.0
	github.com/clj/hrm-profile-tool/instructions v0.0.0
	github.com/clj/hrm-profile-tool/profile v0.0.0
	github.com/clj/hrm-profile-tool/render v0.0.0

)

replace github.com/clj/hrm-profile-tool/cmd/hrm => ./cmd/hrm

replace github.com/clj/hrm-profile-tool/profile => ./profile

replace github.com/clj/hrm-profile-tool/instructions => ./instructions

replace github.com/clj/hrm-profile-tool/render => ./render

replace github.com/clj/hrm-profile-tool/utils/text => ./utils/text

replace github.com/clj/hrm-profile-tool/utils/seekbufio => ./utils/seekbufio
