FROM centos:7



RUN yum  install -y git




#install powershell
RUN curl https://packages.microsoft.com/config/rhel/7/prod.repo |  tee /etc/yum.repos.d/microsoft.repo
RUN yum install -y  zip
RUN yum install -y powershell
RUN yum install -y dotnet-sdk-3.0.x86_64
RUN pwsh -c "Install-Module AWSLambdaPSCore -Scope CurrentUser -Force"
RUN pwsh -c "Install-Module -Name AWS.Tools.Common -Scope CurrentUser -Force"
RUN pwsh -c "Install-Module -Name AWS.Tools.RDS -Scope CurrentUser -Force"
RUN pwsh -c "Install-Module -Name AWS.Tools.EC2 -Scope CurrentUser -Force"

#for production 
#RUN pwsh -c "Install-Module -Name AWSPowerShell.NetCore -Scope CurrentUser -Force"

RUN pwsh -c "Get-AWSPowerShellLambdaTemplate -Force"
RUN pwsh -c "New-AWSPowerShellLambda -ScriptName LambdaFunctionRdsSgFind -Template Basic"






#install ssh 
RUN yum -y install  openssh-server 
RUN rm /etc/ssh/sshd_config
COPY ./powershell/sshd_config /etc/ssh/
RUN chown root:root /etc/ssh/sshd_config
RUN chmod -R 600 /etc/ssh/sshd_config






# Copy custom data
RUN mkdir /app
COPY ./app /app
RUN chmod -R +x /app/*


ENTRYPOINT ["/usr/sbin/init"]
VOLUME [ "/sys/fs/cgroup" ]



#awk 'sub("$", "\r")' uniz.txt > windows.txt




