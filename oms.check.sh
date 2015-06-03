#!/usr/bin/env sh
# 时间：2015-4-14  版本：1.0
# 功能描述：可完成OMSWEB、CC、AN的核查
# 1.将OMSCC_FLOAT_IP变量改成OMSCC的浮动IP
# 2.上传此脚本到omsan或omscc或omswebser账户，执行命令:sh oms.check.sh >check.`hostname`.log
# 3.反馈check.*.log给OMS研发人员
#

##改成OMSCC的浮动IP
OMSCC_FLOAT_IP="192.168.75.23"


echo 
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
CHECKAN=`echo $OMSDIR | grep 'an' |wc -l`
CHECKAN=`echo $CHECKAN`
CHECKCC=`echo $OMSDIR | grep 'cc' |wc -l`
CHECKCC=`echo $CHECKCC`
CHECKWEB=`echo $HOME | grep 'web' |wc -l`
CHECKWEB=`echo $CHECKWEB`

echo "CHECKAN=$CHECKAN"
echo "CHECKCC=$CHECKCC"
echo "CHECKWEB=$CHECKWEB"
echo "OMSCC_FLOAT_IP=$OMSCC_FLOAT_IP"
echo "HOST_NAME=`hostname`"
echo "OS=`uname`"


##此部分核查的是OMSWEB
if [ "$CHECKWEB" = "1" ]
then
	echo 
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "JAVA_HOME=$JAVA_HOME"
	echo "CLASSPATH=$CLASSPATH"
	echo "PATH=$PATH"
	echo "LANG=$LANG"
	echo "CATALINA_HOME=$CATALINA_HOME"
	
	echo 
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "applicationContext.xml"
	APPXMLPATH="$HOME/omsweb/local/tomcat/webapps/cne-web/WEB-INF/classes/applicationContext.xml"
	echo "applicationContext.xml=`ls -l $APPXMLPATH`"
	echo "omsccip="
	grep 'name="ip"' $APPXMLPATH
	echo "omsccport="
	grep 'name="port"' $APPXMLPATH
	echo "ftpServer="
	grep 'name="ftpServer"' $APPXMLPATH
	echo "ftpUserName="
	grep 'name="ftpUserName"' $APPXMLPATH
	echo "ftpPassword="
	grep 'name="ftpPassword"' $APPXMLPATH
	echo "ftprootcatalog="
	grep 'name="ftprootcatalog"' $APPXMLPATH
	echo "webSysSwitchConf="
	grep 'name="webSysSwitchConf"' $APPXMLPATH
	echo "firstlevelmenu="
	grep 'name="firstlevelmenu"' $APPXMLPATH
	echo "isInformAlarmDisplay="
	grep 'name="isInformAlarmDisplay"'  $APPXMLPATH
	
	echo 
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "struts.properties"
	STRUTSPATH="$HOME/omsweb/local/tomcat/webapps/cne-web/WEB-INF/classes/struts.properties"
	echo "struts.properties=`ls -l $STRUTSPATH`"
	echo "struts.multipart.saveDir=`grep 'struts.multipart.saveDir=' $STRUTSPATH`"
	
	echo 
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "server.xml"
	SERVERXMLPATH="$HOME/omsweb/local/tomcat/conf/server.xml"
	echo "struts.properties=`ls -l $SERVERXMLPATH`"
	echo "docBase=`grep 'docBase' $SERVERXMLPATH`"
	
	echo 
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "tomcat status=`ps -ef | grep tomcat|grep start`"
	
	echo
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "catalina.out"
	CATAPATH="$HOME/omsweb/local/tomcat/logs/catalina.out"
	grep "ERROR" $CATAPATH | tail -10
	tail -50 $CATAPATH
	
else
	##核查OMSAN或OMSCC
	echo 
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "PATH=$PATH"
	echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
	echo "OMSDIR=$OMSDIR"
	echo "OMSDOMAINID=$OMSDOMAINID"
	echo "PFMCAPIDIR=$PFMCAPIDIR"
	
	cd $OMSDIR/etc
	echo 
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	if [ "$CHECKAN" = "1" ]
	then
		echo "Subsystem=`grep '<Subsystem>' $OMSDIR/etc/config.oms`"
		echo "serverAddr= serverPort=:"
		tail -10 $OMSDIR/etc/config.outcomm
		echo "check.pfmc.xml=`ls -l $OMSDIR/etc/check.pfmc.xml`"
		echo "check.log.xml=`ls -l $OMSDIR/etc/check.log.xml`"
		echo "check.net.xml=`ls -l $OMSDIR/etc/check.net.xml`"
		echo "check.db.xml=`ls -l $OMSDIR/etc/check.net.xml`"
		echo "alarmcfg=`head -1 $OMSDIR/etc/alarmcfg`"
		echo "ftp.ini=`ls -l $OMSDIR/var/agent/.ftp.ini`"
	else
		echo "config.comm=`grep 'domain id="2"' $OMSDIR/etc/config.comm`"
		echo "config.oms:Database Name=`grep 'Database Name' config.oms`"
		echo "config.oms:FtpHomePath=`grep 'FtpHomePath' config.oms`"
		echo "config.outcomm=:"
		sed -n '/feId="139"/,+4p' $OMSDIR/etc/config.outcomm
		echo "alarmcfg=`head -1 $OMSDIR/etc/alarmcfg`"
	fi
	
	echo 
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "psoms:ininit=`psoms | grep ininit |wc -l`"
	if [ "$CHECKAN" = "1" ]
	then
		echo "psoms:checklog=`psoms | grep checklog |wc -l`"
		echo "psoms:checkpfmc=`psoms | grep checkpfmc |wc -l`"
		echo "psoms:checknet=`psoms | grep checknet |wc -l`"
	fi
	
	cd $OMSDIR/log
	echo 
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "ininit*.log"
	grep "received SIGCHLD signal." ininit*.log | tail -10
	cat ininit*.log | tail -50 
	
	if [ "$CHECKAN" = "1" ]
	then
		echo 
		echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo "agentgate*.log"
		grep "External client link is connecting to server" agentgate*.log | tail -10
		cat agentgate*.log | tail -50 
		
		echo 
		echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo "agentregister*.log"
		grep "Agent register to CC failed." agentregister*.log | tail -10
		cat agentregister*.log | tail -50 
		
		echo 
		echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo "pluginrunner*.log"
		grep "\bresult:" pluginrunner3.1.log|grep -v "(100)" | tail -10
		cat pluginrunner*.log | tail -50 
		
		echo 
		echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo "pluginmanager.log"
		grep -E "(ERROR|FATAL)" pluginmanager*.log | tail -10
		cat pluginmanager*log | tail -50
	else
		echo 
		echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo "procrun.log"
		grep "Failed" procrun.log | tail -10
		cat procrun.log | tail -50
		
		echo 
		echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo "abilityresult*.log"
		grep "Ability-Result-Process Handler process ability result failed." abilityresult*.log |tail -10
		cat abilityresult*.log | tail -50
		
		echo 
		echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo "pmmsgprocessor*.log"
		grep "save pfmc data failed." pmmsgprocessor*.log | tail -10
		cat pmmsgprocessor*.log | tail -50
		
		echo 
		echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo "pmcumulative*.log"
		grep "add record failed." pmcumulative*.log | tail -10
		cat pmcumulative*.log | tail -50
		
		echo 
		echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo "alarmprocessor*.log"
		grep -E "(ERROR|FATAL)" alarmprocessor*.log | tail -10
	fi
	
fi

echo 
echo "Done!"

