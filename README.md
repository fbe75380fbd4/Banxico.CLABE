# Banxico.CLABE

The CLABE (Clave Bancaria Estandarizada, Spanish for "standardized banking cipher" or "standardized bank code") is a banking standard for the numbering of bank accounts in Mexico. This standard is a requirement for the sending and receiving of domestic inter-bank electronic funds transfer since June 1, 2004.

This module provides functions to retrieve/verify catalogs and to get details about a given CLABE as well as validating/testing its control digit.

## Module

Install module from PSGallery

```powershell
Install-Module -Name Banxico.CLABE
```

Or update if already installed

```powershell
Update-Module -Name Banxico.CLABE
```

## Functions

### Get-BranchOfficeData

Lists the branch offices or cities used by CLABE where the checking account is located within Mexico. 

Be aware that there might be multiple branch offices under the same code.

```powershell
Get-BranchOfficeData

Code BranchOffice
---- ------------
010  Aguascalientes
012  Calvillo
014  Jesús María
020  Mexicali
022  Ensenada
...
```

### Get-CLABEInfo

Displays the details about a CLABE like its banking institution and branch office, also validates the control digit.

Validation could be subject to change or failure as it depends on external catalogs.

```powershell
Get-CLABEInfo -CLABE 044939000118359712

Institution   : SCOTIABANK (044)
BranchOffice  : Loreto (939)
AccountNumber : 00011835971
ControlDigit  : 2
Valid         : True
```

### Get-InstitutionData

Retrieves a list of banking institutions from Banxico's web site.

```powershell
Get-InstitutionData

Code Institution         
---- -----------    
133  ACTINVER
062  AFIRME
128  AUTOFIN
127  AZTECA
166  BaBien
...
```
