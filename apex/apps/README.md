f103.sql can be created with:
`apex export -applicationid 103 -skipExportDate -expPubReports -expSavedReports -expIRNotif -expTranslations -expACLAssignments -expOriginalIds -dir apex/f103`
Note that to use this, the code from apex/setup.sql would need to be injected and run using pure SQLcl; not with lb

f103.xml was created with:
`lb genobject -type apex -applicationid 103 -skipExportDate -expPubReports -expSavedReports -expIRNotif -expTranslations -expACLAssignments -expOriginalIds -dir apex/apps`
Note: This method works!!  Use it for now; think about switching to -split when then fix some sort of bug which makes splitting useless.