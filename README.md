# 1. Presentation :

Veeam monitoring with Zabbix, small Powershell script and a template. Using Zabbix sender for active send and Windows task scheduler.

![ZabbixSchema1](https://github.com/issuyah/Veeam-Zabbix-Simple/blob/main/assets/ZabbixSchema1.png)

It will returns backups errors in your dashboard and automatically close the problem when the backup back to a success state :

![Zabbixtrigger](https://github.com/issuyah/Veeam-Zabbix-Simple/blob/main/assets/trigger.png)


# 2. Installation :

## 1. Download the files :

You can download the lastest version of the packages on my github : https://github.com/issuyah/Veeam-Zabbix-Simple

![image0.png](https://github.com/issuyah/Veeam-Zabbix-Simple/blob/main/assets/installation/image0.png)

## 2. Install the zabbix template :

In your zabbix server, import the template with the file “zbx_veeam_templates.yaml”

Go on Templates :

![image1.png](https://github.com/issuyah/Veeam-Zabbix-Simple/blob/main/assets/installation/image1.png)

And import :

![image2.png](https://github.com/issuyah/Veeam-Zabbix-Simple/blob/main/assets/installation/image2.png)

Choose the template and import-it :

![image3.png](https://github.com/issuyah/Veeam-Zabbix-Simple/blob/main/assets/installation/image3.png)

The template is ready, you can now create the host !

## 3. Create the host in Zabbix :

In this part, you just have to create an active host in zabbix :

![image4.png](https://github.com/issuyah/Veeam-Zabbix-Simple/blob/main/assets/installation/image4.png)

- Define a host name
- Select the veeam template “Simple Veeam Zabbix vX”
- If you want, you can use a proxy on the host.

Click now on “Create” or “Update”.

## 4. Configure the client on windows :

### A. Configure the script:

To configure the script, you have to put the folder “zabbix_agent2” at the root of Windows filesystem :

![image5.png](https://github.com/issuyah/Veeam-Zabbix-Simple/blob/main/assets/installation/image5.png)

Go now on “C:\zabbix_agent2\scripts” and modify the file “Veeam-Zabbix-Simple.ps1”

You just have to modify the lines 3 and 4 :

![image6.png](https://github.com/issuyah/Veeam-Zabbix-Simple/blob/main/assets/installation/image6.png)

Save and exit the file.

### B. Test the script

You can now test the script with a powershell command :

“C:\zabbix_agent2\scripts\Veeam-Zabbix-Simple.ps1”

/!\ You maybe have to authorize running scripts into your server. /!\

Result :

![image14.png](https://github.com/issuyah/Veeam-Zabbix-Simple/blob/main/assets/installation/image14.png)

If like me, all the jobs are in “failed”, just wait 5 minutes and retry to launch it. Zabbix server have to discover the list of jobs before adding the values.

![image13.png](https://github.com/issuyah/Veeam-Zabbix-Simple/blob/main/assets/installation/image13.png)

You can now see the result on your zabbix lastest data :

![image7.png](https://github.com/issuyah/Veeam-Zabbix-Simple/blob/main/assets/installation/image7.png)

C. Configure the task scheduler

Now the script are working but you have to push the data automatically.

So to do that, you have to import the file “Veeam-Zabbix-Simple-task.xml” into your task scheduler.

Open the task scheduler : 

![image8.png](https://github.com/issuyah/Veeam-Zabbix-Simple/blob/main/assets/installation/image8.png)

Go on action and import task :

![image9.png](https://github.com/issuyah/Veeam-Zabbix-Simple/blob/main/assets/installation/image9.png)

Select the file on the explorer :

![image10.png](https://github.com/issuyah/Veeam-Zabbix-Simple/blob/main/assets/installation/image10.png)

Now you have to put your admin account into the task to run it when the session is locked :

![image11.png](https://github.com/issuyah/Veeam-Zabbix-Simple/blob/main/assets/installation/image11.png)

You can now save and exit this configuration window and test the task :

![image12.png](https://github.com/issuyah/Veeam-Zabbix-Simple/blob/main/assets/installation/image12.png)

You have now finished the installation. You can change the delta between each send by tweaking the planified task.
