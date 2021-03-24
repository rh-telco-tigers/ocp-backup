Description:

This Shell script will enumerate or backup all resources inside of Openshift into a nice directory structure 

How it Works:

Basically, the script loops through all non-namespaced resources first and creates a directory structure based on that.  Following the creation of the non-namespaced resources, all namespaced resources are created inside a subdirectory for each namespace that exists in the cluster.  Lastly, a pods.txt and events.txt file is created to show the status of the cluster at the time of backup.

Here is a description of the directories created under $BACKUPDIR/<datetime>

  ./apiresources

  ./apiresources/non-namespaced --> These are cluster-wide resources

  ./apiresources/non-namespaced/$typeofobject/$nameofobject --> The name of the object contains the contents of the resource in YAML format 

  ./apiresources/namespaced/<namespace-name>/$typeofobject/$nameofobject --> The name of the object contains the contents of the resource in YAML format

  ./pods.txt --> output of oc get pods -o wide 

  ./events.txt --> output of oc get events
  
Use-Cases:

There are a few reasons this may be useful

1.  Instead of restoring a whole etcd backup, you can just restore just the one object/resource.
2.  You would like to visualize all components of the cluster at a specific time
3.  You would like to visualize a single resources in Openshift from a specific time.
4.  You would like to view the status of pods and events based on the time of the backup.


To use:

Edit the ocp-backup.sh file and edit the KUBECONFIG and BACKUPDIR variables.

Run directly through Shell or a cron-job

./ocp-backup.sh 2> /dev/null


