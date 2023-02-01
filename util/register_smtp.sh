#!/bin/bash

set -e

write_conf() {
	case $1 in
		163) 
			echo "set from=xugang_2001@163.com" > /etc/mail.rc
			echo "set smtp=smtps://smtp.163.com:465" >> /etc/mail.rc
			echo "set smtp-auth-user=xugang_2001@163.com" >> /etc/mail.rc
			echo "set smtp-auth-password=ODXJJUCSTPGMPPJF" >> /etc/mail.rc
		;;
		qq) 
			echo "set from=wells-xu@qq.com" > /etc/mail.rc
			echo "set smtp=smtps://smtp.qq.com:465" >> /etc/mail.rc
			echo "set smtp-auth-user=wells-xu@qq.com" >> /etc/mail.rc
			echo "set smtp-auth-password=vxmwcrgcjoljcbdg" >> /etc/mail.rc
		;;
		*)
			echo "command invalid: $1"
			exit 1
		;;
	esac

	echo "set smtp-auth=login" >> /etc/mail.rc
	echo "set ssl-verify=ignore" >> /etc/mail.rc
	echo "set nss-config-dir=/root/.certs" >> /etc/mail.rc
}

register_email() {
	write_conf $1
	local dir_cert=/root/.certs
	mkdir -p $dir_cert
	rm -fv $dir_cert/*
	echo -n | openssl s_client -connect smtp.$1.com:465 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > $dir_cert/$1.crt
	#添加证书到数据库（以qq.crt为输入证书）
	certutil -A -n "GeoTrust SSL CA" -t "C,," -d $dir_cert -i $dir_cert/qq.crt
	certutil -A -n "GeoTrust Global CA" -t "C,," -d $dir_cert -i $dir_cert/qq.crt
	#列出指定目录下的证书,经过试验，这一步可以不需要
	certutil -L -d $dir_cert
	#指明受信任证书、防报错
	certutil -A -n "GeoTrust SSL CA - G3" -t "Pu,Pu,Pu" -d $dir_cert -i $dir_cert/$1.crt
}

main() {
	case $1 in
		163 | qq) 
			register_email $1
		;;
		*)
			echo "command invalid: $1"
			exit 1
		;;
	esac
}

main "$@"

