/root/delete.sh

/root/scripts/provisioning/provisionMachines.sh 2 2000 192.168.10.130 1_3_4_tiny scripts 1 mykey

sleep 100

/root/sshkeygen.sh

/root/scripts/netperf/controlNetperf.sh '192.168.10.130;192.168.10.131' 10 100 TX 2_2_1_tiny 192.168.10.185 /root/mykey.priv
sleep 10
/root/scripts/netperf/controlNetperf.sh '192.168.10.130;192.168.10.131' 10 100 RX 2_2_1_tiny 192.168.10.185 /root/mykey.priv

/root/delete.sh

/root/scripts/provisioning/provisionMachines.sh 4 2000 192.168.10.130 1_3_4_tiny scripts 1 mykey

sleep 100

/root/sshkeygen.sh

/root/scripts/netperf/controlNetperf.sh '192.168.10.130;192.168.10.131;192.168.10.132;192.168.10.133' 10 100 TX 2_2_2_tiny 192.168.10.185 /root/mykey.priv
sleep 10
/root/scripts/netperf/controlNetperf.sh '192.168.10.130;192.168.10.131;192.168.10.132;192.168.10.133' 10 100 RX 2_2_2_tiny 192.168.10.185 /root/mykey.priv

/root/delete.sh

/root/scripts/provisioning/provisionMachines.sh 8 2000 192.168.10.130 1_3_4_tiny scripts 1 mykey
/root/sshkeygen.sh

sleep 100

/root/scripts/netperf/controlNetperf.sh '192.168.10.130;192.168.10.131;192.168.10.132;192.168.10.133;192.168.10.134;192.168.10.135;192.168.10.136;192.168.10.137' 10 100 TX 2_2_3_tiny 192.168.10.185 mykey
sleep 10
/root/scripts/netperf/controlNetperf.sh '192.168.10.130;192.168.10.131;192.168.10.132;192.168.10.133;192.168.10.134;192.168.10.135;192.168.10.136;192.168.10.137' 10 100 RX 2_2_3_tiny 192.168.10.185 mykey

/root/delete.sh
