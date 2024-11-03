FROM gitpod/workspace-full-vnc
SHELL ["/bin/bash", "-c"]
ENV ANDROID_HOME=$HOME/Android/Sdk
ENV PATH="$HOME/Android/Sdk/emulator:$HOME/Android/Sdk/tools:$HOME/Android/Sdk/cmdline-tools/latest/bin:$HOME/Android/Sdk/platform-tools:$PATH"

# Install Open JDK for android and other dependencies
USER root

RUN curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.gpg | sudo apt-key add - \
     && curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.list | sudo tee /etc/apt/sources.list.d/tailscale.list \
     && apt-get update \
     && apt-get install -y tailscale
RUN update-alternatives --set ip6tables /usr/sbin/ip6tables-nft

# Make some changes for our vnc client 
RUN sed -i 's|resize=scale|resize=remote|g' /opt/novnc/index.html 

USER gitpod

# Install Android studio and dependencies
RUN cd $HOME && wget https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2022.2.1.18/android-studio-2022.2.1.18-linux.tar.gz && tar zxvf android-studio-2022.2.1.18-linux.tar.gz  && rm -r android-studio-2022.2.1.18-linux.tar.gz 

# Install Android SDK
RUN mkdir -p /home/gitpod/Android/Sdk  
RUN wget "https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip" 
RUN unzip "commandlinetools-linux-9477386_latest.zip" -d $ANDROID_HOME 
RUN rm -f "commandlinetools-linux-9477386_latest.zip" 
RUN mkdir -p $ANDROID_HOME/cmdline-tools/latest 
RUN mv $ANDROID_HOME/cmdline-tools/{bin,lib} $ANDROID_HOME/cmdline-tools/latest 
COPY idea.properties /home/gitpod/android-studio/bin/idea.properties 