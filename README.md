# WmiAgent

cscript WmiVbsAgent.vbs http://someserver/wmi/back/end/receiver

### TODO Checklist:
 - [ ] Local agent in windows native language (no app install needed)[vbs]
  --[X] only native script language
  --[X] connect to server through http(s)
  --[X] get wmi classes and properties to send
  --[X] parse and collect wmi info
  --[ ] send wmi info through http post
  --[ ] ignore invalid wmi queries and define timeout to queries
  --[ ] return Exitcode to script caller [task scheduler]
 - [ ] Backend code in dynamic web based language [php]
  --[X] get classes from database table
 - [ ] Database to retain data, next to web language [mariadb]
 - [ ] Agent installer/deployer/updater in windows native language
