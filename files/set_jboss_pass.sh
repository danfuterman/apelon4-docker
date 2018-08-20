#/bin/bash

#generate JBoss Management user
PASS=${JBOSS_PASS:-$(pwgen -s 12 1)}
_word=$( [ ${JBOSS_PASS} ] && echo "preset" || echo "random" )

echo "=> Configuring apelonadmin user with a ${_word} password in JBoss"
${JBOSS_HOME}/bin/add-user.sh --silent=true admin ${PASS}
echo "=> Done!"
echo "========================================================================"
echo "You can now configure to this JBoss server using:"
echo ""
echo "    admin : ${PASS}"
echo ""
echo "========================================================================"

touch /.jboss_admin_pass_configured

#generate DTS Admin user
DTSADMIN_PASS=dtsadmin
echo "=> Configuring dtsadminuser user password in JBoss"
${JBOSS_HOME}/bin/add-user.sh --silent=true -a dtsadminuser ${DTSADMIN_PASS}
echo "=> Done!"
echo "========================================================================"
echo "You can now configure ApelonDTS using:"
echo ""
echo "    dtsadminuser : ${DTSADMIN_PASS}"
echo ""
echo "========================================================================"

touch /.jboss_dtsadmin_pass_configured

#generate DTS user
DTSUSER_PASS=dts
echo "=> Configuring dtsadminuser user password in JBoss"
${JBOSS_HOME}/bin/add-user.sh --silent=true -a dtsuser ${DTSUSER_PASS}
echo "=> Done!"
echo "========================================================================"
echo "You can now access ApelonDTS using:"
echo ""
echo "    dtsuser : ${DTSUSER_PASS}"
echo ""
echo "========================================================================"

touch /.jboss_dtsuser_pass_configured


