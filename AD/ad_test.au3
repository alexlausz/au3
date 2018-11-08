#include "D:\github\Autoit AD 1.4.10.0\AD.au3"

$iResult = _AD_Open("byadmin@by.com", "bill@123admin", "", "byszdcsrv01.by.com")

;$sAD_OU = "Domain Controllers" ; Not work

;~ $aObjects = _AD_GetObjectsInOU("", "(&(objectCategory=computer)(objectClass=computer)(description=*)(!description=szdrz*)(!description=Administrator*))", 2, "name,description")
;~ _ArrayDisplay($aObjects)

$aObjects = _AD_GetObjectsInOU("", "(&(objectCategory=computer)(objectClass=computer)(description=吴雪玉*))", 2, "name,description")
_ArrayDisplay($aObjects)

;~ $aObjects = _AD_GetObjectsInOU("", "(&(objectCategory=person)(objectClass=user)(!description=*))", 2, "name,description")
;~ _ArrayDisplay($aObjects)

;~ $aObjects = _AD_GetObjectsInOU("", "(&(objectCategory=person)(objectClass=user)(!description=*))", 2, "name,description")
;~ _ArrayDisplay($aObjects)
