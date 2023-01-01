FROM ubuntu:20.04

ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 使うコマンドをインストール
RUN apt update && \
    apt -y upgrade && \
    apt install -y build-essential && \
    apt install -y software-properties-common && \
    apt install -y curl git man unzip vim wget sudo
    # ape install -y sysstat python3-matplotlib python3-pil fonts-takao fio qemu-kvm virt-manager libvirt-clients virtinst jq docker.io containerd libvirt-daemon-system
# rootだと色々と不便なので，ユーザーを作成
RUN useradd -m hoge
# ルート権限を付与
RUN gpasswd -a hoge sudo
# パスワードはpassに設定
RUN echo 'hoge:pass' | chpasswd
# sshログイン時のシェルをbashに設定
RUN sudo sed -i 's/hoge:x:1000:1000::\/home\/hoge:\/bin\/sh/hoge:x:1000:1000::\/home\/hoge:\/bin\/bash/g' /etc/passwd

# sshするための設定（公式サイト参考）
RUN apt install -y openssh-server
RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
# RUN apt update && apt install binutils build-essential sysstat python3-matplotlib python3-pil fonts-takao fio qemu-kvm virt-manager libvirt-clients virtinst jq docker.io containerd libvirt-daemon-system
