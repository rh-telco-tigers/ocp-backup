#! /bin/bash
# This script will backup or enumerate all resources inside of OCP
# Keith Calligan <kcalliga@redhat.com>

#set -x

# Vars
# Source KUBECONFIG
KUBECONFIG=/home/ansible/ai-kubeconfig
# Set Backup Directory
BACKUPDIR=/home/ansible/backups

# Make backup directory
mkdir -p $BACKUPDIR;

# Get Date/Time for Directory
DATE=`date +%m%d%y%H%M%S`;

#Make Directory under backup based on datetime
mkdir $BACKUPDIR/$DATE

# Get listing of all non-namespaced resources

for apinonnamespace in `oc api-resources --namespaced=false|awk '{print $1}'|grep -v NAME`; do
# Create Directory for these apiresources to hold backup objects
        mkdir -p $BACKUPDIR/$DATE/apiresources/non-name-spaced/$apinonnamespace/descriptions;
# Grab Each Sub Object and Describe it
        	for subobject in `oc get $apinonnamespace|grep -v NAME|awk '{print $1}' 2> /dev/null`; do
        		oc get $apinonnamespace/$subobject -o yaml > $BACKUPDIR/$DATE/apiresources/non-name-spaced/$apinonnamespace/descriptions/$subobject;
        	done;
done;

# Grab each namespace name

for namespaces in `oc get namespace|awk '{print $1}'|grep -v NAME`; do
# Create Directory for these apiresources to hold backup objects
        mkdir -p $BACKUPDIR/$DATE/apiresources/namespaced/$namespaces;
# Grab Each namespace based resource
                for apinamespace in `oc api-resources --namespaced=true|awk '{print $1}'|grep -v NAME`; do
                        mkdir -p $BACKUPDIR/$DATE/apiresources/namespaced/$namespaces/$apinamespace;
			for namespaceobject in `oc get $apinamespace -n $namespaces|awk '{print $1}'|grep -v NAME`; do
				oc get $apinamespace/$namespaceobject -n $namespaces -o yaml > $BACKUPDIR/$DATE/apiresources/namespaced/$namespaces/$apinamespace/$namespaceobject;
			done;
                done;
done;

# Grab Some Status Info for Reference

oc get po -o wide -A > $BACKUPDIR/$DATE/podstatus.txt;

oc get events -A > $BACKUPDIR/$DATE/events.txt;
