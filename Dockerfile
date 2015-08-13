FROM      ubuntu:14.04.2
MAINTAINER Olexander Kutsenko <olexander.kutsenko@gmail.com>

#install 
RUN apt-get update -y
RUN apt-get install -y software-properties-common python-software-properties
RUN apt-get install -y git git-core vim nano mc nginx screen curl unzip zip
COPY configs/nginx/default /etc/nginx/sites-available/default

# SSH service
RUN sudo apt-get install -y openssh-server openssh-client
RUN sudo mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
#change 'pass' to your secret password
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

#configs bash start
COPY configs/autostart.sh /root/autostart.sh
RUN chmod +x /root/autostart.sh
COPY configs/bash.bashrc /etc/bash.bashrc

#ant install
RUN add-apt-repository -y ppa:webupd8team/java 
RUN apt-get update
RUN apt-get install -y default-jdk
#RUN apt-get install -y oracle-java7-installer 
#RUN apt-get install -y oracle-java8-installer
RUN apt-get install -y ant

#aliases
RUN alias ll='ls -la'

#Install Gradle
RUN echo "Start Setup Gradle"
RUN add-apt-repository -y ppa:cwchien/gradle
RUN apt-get update
RUN apt-get install -y gradle
RUN echo "Start Setup Gradle is done"

#install Android SDK
RUN cd /home && wget http://dl.google.com/android/android-sdk_r24.3.3-linux.tgz
RUN cd /home && tar -xvzf /home/android-sdk_r24.3.3-linux.tgz
RUN mv /home/android-sdk-linux /opt
RUN rm /home/android-sdk_r24.3.3-linux.tgz
RUN export ANDROID_HOME=/opt/android-sdk-linux
RUN export PATH=${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
RUN echo "y" | android update sdk -u --all

#install Android NDK
RUN cd /home && wget http://dl.google.com/android/ndk/android-ndk-r10e-linux-x86_64.bin
RUN chmod +x /home/android-ndk-r10e-linux-x86_64.bin
RUN /home/android-ndk-r10e-linux-x86_64.bin
RUN mv /home/android-ndk-r10e /opt
RUN rm /home/android-ndk-r10e-linux-x86_64.bin
RUN export ANDROID_NDK=/opt/android-ndk-r10e

#Install TeamCity BuildAgent
COPY buildAgent /opt
RUN chmod +x /opt/buildAgent/bin/*.sh 

#open ports
EXPOSE 80 22
