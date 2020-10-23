#!/bin/bash

RMQADMIN_PATH=/root
DEFAULT_MAX_LENGTH=1000000

checkQueue() {
    len=$(rabbitmqctl list_queues -p ${1} | grep -x "${2}\s.*" | awk '{print $2}')

    re='^[0-9]+$'
    if [[ ${len} =~ $re ]] ; then
      if [ ${len} -gt 0 ]; then
        str="count_node=\$(${RMQADMIN_PATH}/rabbitmqadmin --format=pretty_json list queues name sync$
        eval $str

        str="count_sync=\$(${RMQADMIN_PATH}/rabbitmqadmin --format=pretty_json list queues name sync$
        eval $str

        synch ${count_node} ${count_sync} ${1} ${2} &
      else
        echo Check queue ${2} on ${1}... queue size 0
      fi
    fi
}

synch() {
   if [ $2 -ne $1 ]; then
      echo
      echo "Queue ${4} on ${3} not synch!"
      len=$(rabbitmqctl list_queues -p ${3} | grep -x "^${4}\s.*" | awk '{print $2}')
      re='^[0-9]+$'
      if [[ ${len} =~ $re ]] ; then
        if [ ${len} -lt ${DEFAULT_MAX_LENGTH} ]; then
           echo "Queue: ${4} on ${3} has: ${len} messages"
           rabbitmqctl sync_queue ${4} -p ${3} && echo "Queue: ${4} on ${3} synchronized!"
        else
           echo skipped limit=${DEFAULT_MAX_LENGTH}
           echo "Queue: ${4} on ${3} has: ${len} messages (OVER LIMIT!)"
        fi
      fi
   else
      echo "Queue: ${4} on ${3} - OK!"
   fi
}

admin=$(which rabbitmqadmin 2> /dev/null)
if [ $? -gt 0 ]; then
        if [ -x ${RMQADMIN_PATH}/rabbitmqadmin ]; then
                ctl=$(which rabbitmqctl 2> /dev/null)
                if [ $? -gt 0 ]; then
                        echo "ERROR: rabbitmqctl not installed"
                        exit 1
                fi
        else
                echo "ERROR: rabbitmqadmin not in PATH"
                exit 1
        fi
fi

vhosts=$(rabbitmqctl list_vhosts | sort)
eval 'vhostArray=($vhosts)'

for ((i=0;i< ${#vhostArray[@]} ;i+=1))
do
   v=$(rabbitmqctl list_queues -p ${vhostArray[$i]} -q | grep -v "^amq.*" | sort -k 2 -r)
   eval 'queueArray=($v)'

   for ((a=0;a< ${#queueArray[@]} ;a+=2))
   do
       while [ $(jobs | wc -l) -gt 20 ]; do
           sleep 1
       done
       checkQueue ${vhostArray[$i]} ${queueArray[$a]} &
   done
done
