# 1. Presentation :

Veeam monitoring with Zabbix, small Powershell script and a template. Using Zabbix sender for active send and Windows task scheduler.

![ZabbixSchema1](https://github.com/issuyah/Veeam-Zabbix-Simple/blob/main/assets/ZabbixSchema1.png "ZabbixSchema1")

# 2. Installation :

## 1. Download the files :

You can download the lastest version of the packages on my github : https://github.com/issuyah/Veeam-Zabbix-Simple or in the sibio nextcloud share : \IT\Outils\zabbix\Clients\Veeam-Zabbix-Simple-main

![image0.png](https://github.com/issuyah/Veeam-Zabbix-Simple/blob/main/assets/installation/image0.png "0")

## 2. Install the zabbix template :

In your zabbix server, import the template with the file “zbx_veeam_templates.yaml”

Go on Templates :

![image1.png](https://github.com/issuyah/Veeam-Zabbix-Simple/blob/main/assets/installation/image1.png "1")

And import :

![image2.png](https://github.com/issuyah/Veeam-Zabbix-Simple/blob/main/assets/installation/image2.png "2")

Choose the template and import-it :

![image.png](https://github.com/issuyah/Veeam-Zabbix-Simple/blob/main/assets/installation/image3.png "3")

The template is ready, you can now create the host !

## 3. Create the host in Zabbix :

In this part, you just have to create an active host in zabbix :

![image.png](image%204.png)

- Define a host name
- Select the veeam template “Simple Veeam Zabbix vX”
- If you want, you can use a proxy on the host.

Click now on “Create” or “Update”.

## 4. Configure the client on windows :

### A. Configure the script:

To configure the script, you have to put the folder “zabbix_agent2” at the root of Windows filesystem :

![image.png](image%205.png)

Go now on “C:\zabbix_agent2\scripts” and modify the file “Veeam-Zabbix-Simple.ps1”

You just have to modify the lines 3 and 4 :

![image.png](image%206.png)

Save and exit the file.

### B. Test the script

You can now test the script with a powershell command :

“C:\zabbix_agent2\scripts\Veeam-Zabbix-Simple.ps1”

/!\ You maybe have to authorize running scripts into your server. /!\

Result :

![1.png](1.png)

If like me, all the jobs are in “failed”, just wait 5 minutes and retry to lanch it. Zabbix server have to discover the list of the jobs before adding the values.

![1.png](1%201.png)

You can now see the result on your zabbix lastest data :

![image.png](image%207.png)

C. Configure the task scheduler

Now the script are working but you have to push the data automatically.

So to do that, you have to import the file “Veeam-Zabbix-Simple-task.xml” into your task scheduler.

Open the task scheduler : 

![image.png](image%208.png)

Go on action and import task :

![image.png](image%209.png)

Select the file on the explorer :

![image.png](image%2010.png)

Now you have to put your admin account into the task to run it when the session is locked :

![image.png](image%2011.png)

You can now save and exit this configuration window and test the task :

![image.png](image%2012.png)

You have now finished the installation. You can change the delta between each send by tweaking the planified task.