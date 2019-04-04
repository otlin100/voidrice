#!/usr/bin/env bash
if [ -z "$BASH" ] ; then
   bash  $0
   exit
fi



my_name=$0


function setup_environment {
  bf=""
  n=""
  ORGANISATION="Heinrich-Heine-Universität Düsseldorf"
  URL="http://www.zim.hhu.de/services-des-zim/netz/netzzugang/wireless-lan.html"
  SUPPORT="wlan@hhu.de"
if [ ! -z "$DISPLAY" ] ; then
  if which zenity 1>/dev/null 2>&1 ; then
    ZENITY=`which zenity`
  elif which kdialog 1>/dev/null 2>&1 ; then
    KDIALOG=`which kdialog`
  else
    if tty > /dev/null 2>&1 ; then
      if  echo $TERM | grep -E -q "xterm|gnome-terminal|lxterminal"  ; then
        bf="[1m";
        n="[0m";
      fi
    else
      find_xterm
      if [ -n "$XT" ] ; then
        $XT -e $my_name
      fi
    fi
  fi
fi
}

function split_line {
echo $1 | awk  -F '\\\\n' 'END {  for(i=1; i <= NF; i++) print $i }'
}

function find_xterm {
terms="xterm aterm wterm lxterminal rxvt gnome-terminal konsole"
for t in $terms
do
  if which $t > /dev/null 2>&1 ; then
  XT=$t
  break
  fi
done
}


function ask {
     T="DFN eduroam CAT"
#  if ! [ -z "$3" ] ; then
#     T="$T: $3"
#  fi
  if [ ! -z $KDIALOG ] ; then
     if $KDIALOG --yesno "${1}\n${2}?" --title "$T" ; then
       return 0
     else
       return 1
     fi
  fi
  if [ ! -z $ZENITY ] ; then
     text=`echo "${1}" | fmt -w60`
     if $ZENITY --no-wrap --question --text="${text}\n${2}?" --title="$T" 2>/dev/null ; then
       return 0
     else
       return 1
     fi
  fi

  yes=Y
  no=N
  yes1=`echo $yes | awk '{ print toupper($0) }'`
  no1=`echo $no | awk '{ print toupper($0) }'`

  if [ $3 == "0" ]; then
    def=$yes
  else
    def=$no
  fi

  echo "";
  while true
  do
  split_line "$1"
  read -p "${bf}$2 ${yes}/${no}? [${def}]:$n " answer
  if [ -z "$answer" ] ; then
    answer=${def}
  fi
  answer=`echo $answer | awk '{ print toupper($0) }'`
  case "$answer" in
    ${yes1})
       return 0
       ;;
    ${no1})
       return 1
       ;;
  esac
  done
}

function alert {
  if [ ! -z $KDIALOG ] ; then
     $KDIALOG --sorry "${1}"
     return
  fi
  if [ ! -z $ZENITY ] ; then
     $ZENITY --warning --text="$1" 2>/dev/null
     return
  fi
  echo "$1"

}

function show_info {
  if [ ! -z $KDIALOG ] ; then
     $KDIALOG --msgbox "${1}"
     return
  fi
  if [ ! -z $ZENITY ] ; then
     $ZENITY --info --width=500 --text="$1" 2>/dev/null
     return
  fi
  split_line "$1"
}

function confirm_exit {
  if [ ! -z $KDIALOG ] ; then
     if $KDIALOG --yesno "Really quit?"  ; then
     exit 1
     fi
  fi
  if [ ! -z $ZENITY ] ; then
     if $ZENITY --question --text="Really quit?" 2>/dev/null ; then
        exit 1
     fi
  fi
}



function prompt_nonempty_string {
  prompt=$2
  if [ ! -z $ZENITY ] ; then
    if [ $1 -eq 0 ] ; then
     H="--hide-text "
    fi
    if ! [ -z "$3" ] ; then
     D="--entry-text=$3"
    fi
  elif [ ! -z $KDIALOG ] ; then
    if [ $1 -eq 0 ] ; then
     H="--password"
    else
     H="--inputbox"
    fi
  fi


  out_s="";
  if [ ! -z $ZENITY ] ; then
    while [ ! "$out_s" ] ; do
      out_s=`$ZENITY --entry --width=300 $H $D --text "$prompt" 2>/dev/null`
      if [ $? -ne 0 ] ; then
        confirm_exit
      fi
    done
  elif [ ! -z $KDIALOG ] ; then
    while [ ! "$out_s" ] ; do
      out_s=`$KDIALOG $H "$prompt" "$3"`
      if [ $? -ne 0 ] ; then
        confirm_exit
      fi
    done
  else
    while [ ! "$out_s" ] ; do
      read -p "${prompt}: " out_s
    done
  fi
  echo "$out_s";
}

function user_cred {
  PASSWORD="a"
  PASSWORD1="b"

  if ! USER_NAME=`prompt_nonempty_string 1 "enter your userid"` ; then
    exit 1
  fi

  while [ "$PASSWORD" != "$PASSWORD1" ]
  do
    if ! PASSWORD=`prompt_nonempty_string 0 "enter your password"` ; then
      exit 1
    fi
    if ! PASSWORD1=`prompt_nonempty_string 0 "repeat your password"` ; then
      exit 1
    fi
    if [ "$PASSWORD" != "$PASSWORD1" ] ; then
      alert "passwords do not match"
    fi
  done
}
setup_environment
show_info "This installer has been prepared for ${ORGANISATION}\n\nMore information and comments:\n\nEMAIL: ${SUPPORT}\nWWW: ${URL}\n\nInstaller created with software from the GEANT project."
if ! ask "This installer will only work properly if you are a member of ${bf}Heinrich-Heine-Universität Düsseldorf.${n}" "Continue" 1 ; then exit; fi
if [ -d $XDG_CONFIG_HOME/cat_installer ] ; then
   if ! ask "Directory $XDG_CONFIG_HOME/cat_installer exists; some of its files may be overwritten." "Continue" 1 ; then exit; fi
else
  mkdir $XDG_CONFIG_HOME/cat_installer
fi
# save certificates
echo "-----BEGIN CERTIFICATE-----
MIIFmjCCBIKgAwIBAgIHF6/2tctFvTANBgkqhkiG9w0BAQsFADBaMQswCQYDVQQG
EwJERTETMBEGA1UEChMKREZOLVZlcmVpbjEQMA4GA1UECxMHREZOLVBLSTEkMCIG
A1UEAxMbREZOLVZlcmVpbiBQQ0EgR2xvYmFsIC0gRzAxMB4XDTE0MDYwNTE0MDUy
NVoXDTE5MDcwOTIzNTkwMFowgboxCzAJBgNVBAYTAkRFMRwwGgYDVQQIExNOb3Jk
cmhlaW4tV2VzdGZhbGVuMRQwEgYDVQQHEwtEdWVzc2VsZG9yZjEwMC4GA1UEChMn
SGVpbnJpY2gtSGVpbmUtVW5pdmVyc2l0YWV0IER1ZXNzZWxkb3JmMR8wHQYDVQQD
ExZVbmkgRHVlc3NlbGRvcmYgQ0EtRzAxMSQwIgYJKoZIhvcNAQkBFhVjYUB1bmkt
ZHVlc3NlbGRvcmYuZGUwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCl
7FkFA1tnbY34LVQfRNI4VARBr76NSB+6SIaWCPvJ6bUgxWXl7Xp+Xa2V2tB+ZQdX
1LexViCHs04paArI5Om/Dbxz2nyheNBYjtVg5ZICRXPetWQuZCUCDfRPYqqEY9fJ
6pyAUVodqEjKyWIxdeo5v7W9TaweP9YeNl53LoeV/ryOxOv2z6JN5ZVCLKCkE+C/
/MoEWwNukcDAsXGqcJhRtkXpa1T7xaMsd5BysSvk2hsEp3lVHnVmw7ndNK8XYw/k
I+rc6AEzlYWpfRYqayXkJG0Duy7WaWF3jFl918QwVAzFwWOOe3+Vd8DfKtVtDWx2
A2kLWwSKG+URZlb/QBQ7AgMBAAGjggICMIIB/jASBgNVHRMBAf8ECDAGAQH/AgEB
MA4GA1UdDwEB/wQEAwIBBjARBgNVHSAECjAIMAYGBFUdIAAwHQYDVR0OBBYEFGIk
MYSir4cwAn7Nj3Fb9oS1Suw2MB8GA1UdIwQYMBaAFEm3xs/oPR9/6kR7Eyn38Qpw
Pt5kMCAGA1UdEQQZMBeBFWNhQHVuaS1kdWVzc2VsZG9yZi5kZTCBiAYDVR0fBIGA
MH4wPaA7oDmGN2h0dHA6Ly9jZHAxLnBjYS5kZm4uZGUvZ2xvYmFsLXJvb3QtY2Ev
cHViL2NybC9jYWNybC5jcmwwPaA7oDmGN2h0dHA6Ly9jZHAyLnBjYS5kZm4uZGUv
Z2xvYmFsLXJvb3QtY2EvcHViL2NybC9jYWNybC5jcmwwgdcGCCsGAQUFBwEBBIHK
MIHHMDMGCCsGAQUFBzABhidodHRwOi8vb2NzcC5wY2EuZGZuLmRlL09DU1AtU2Vy
dmVyL09DU1AwRwYIKwYBBQUHMAKGO2h0dHA6Ly9jZHAxLnBjYS5kZm4uZGUvZ2xv
YmFsLXJvb3QtY2EvcHViL2NhY2VydC9jYWNlcnQuY3J0MEcGCCsGAQUFBzAChjto
dHRwOi8vY2RwMi5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWNhL3B1Yi9jYWNlcnQv
Y2FjZXJ0LmNydDANBgkqhkiG9w0BAQsFAAOCAQEA5v4/H4YOahl2GAvPOXV9Ll15
EX5XdKux9gjtKsVbor/9LDqYs0Cr7IQijUqiG6yJdQUMUJphyYsKSzQG2PFggrJY
3v2tP8f4XRLUjVgVDKY3kQdFA2MKQt+8vpwaLZO0YJwxRBIEeylj0T9ShN4WEsNy
xYaIlWnZHoiphbOMUPNHkah2xz5QRtSFPM0pcSzU8MyQfcn5SKDaoOSXvEuuzjea
F33JDIy7OwAyr/8HuEse17HHLVmlvRjlsbzHvNaZ1L5Hl4go7DNUv3LnHWV6XT5S
BbnxKqBjPCrSEZBdltnL4hpsiDTRegeEebrGaur/kZUnhG+i9RjYangLr3owKQ==
-----END CERTIFICATE-----

-----BEGIN CERTIFICATE-----
MIIE1TCCA72gAwIBAgIIUE7G9T0RtGQwDQYJKoZIhvcNAQELBQAwcTELMAkGA1UE
BhMCREUxHDAaBgNVBAoTE0RldXRzY2hlIFRlbGVrb20gQUcxHzAdBgNVBAsTFlQt
VGVsZVNlYyBUcnVzdCBDZW50ZXIxIzAhBgNVBAMTGkRldXRzY2hlIFRlbGVrb20g
Um9vdCBDQSAyMB4XDTE0MDcyMjEyMDgyNloXDTE5MDcwOTIzNTkwMFowWjELMAkG
A1UEBhMCREUxEzARBgNVBAoTCkRGTi1WZXJlaW4xEDAOBgNVBAsTB0RGTi1QS0kx
JDAiBgNVBAMTG0RGTi1WZXJlaW4gUENBIEdsb2JhbCAtIEcwMTCCASIwDQYJKoZI
hvcNAQEBBQADggEPADCCAQoCggEBAOmbw2eF+Q2u9Y1Uw5ZQNT1i6W5M7ZTXAFuV
InTUIOs0j9bswDEEC5mB4qYU0lKgKCOEi3SJBF5b4OJ4wXjLFssoNTl7LZBF0O2g
AHp8v0oOGwDDhulcKzERewzzgiRDjBw4i2poAJru3E94q9LGE5t2re7eJujvAa90
D8EJovZrzr3TzRQwT/Xl46TIYpuCGgMnMA0CZWBN7dEJIyqWNVgn03bGcbaQHcTt
/zWGfW8zs9sPxRHCioOhlF1Ba9jSEPVM/cpRrNm975KDu9rrixZWVkPP4dUTPaYf
JzDNSVTbyRM0mnF1xWzqpwuY+SGdJ68+ozk5SGqMrcmZ+8MS8r0CAwEAAaOCAYYw
ggGCMA4GA1UdDwEB/wQEAwIBBjAdBgNVHQ4EFgQUSbfGz+g9H3/qRHsTKffxCnA+
3mQwHwYDVR0jBBgwFoAUMcN5G7r1U9cX4Il6LRdsCrMrnTMwEgYDVR0TAQH/BAgw
BgEB/wIBAjBiBgNVHSAEWzBZMBEGDysGAQQBga0hgiwBAQQCAjARBg8rBgEEAYGt
IYIsAQEEAwAwEQYPKwYBBAGBrSGCLAEBBAMBMA8GDSsGAQQBga0hgiwBAQQwDQYL
KwYBBAGBrSGCLB4wPgYDVR0fBDcwNTAzoDGgL4YtaHR0cDovL3BraTAzMzYudGVs
ZXNlYy5kZS9ybC9EVF9ST09UX0NBXzIuY3JsMHgGCCsGAQUFBwEBBGwwajAsBggr
BgEFBQcwAYYgaHR0cDovL29jc3AwMzM2LnRlbGVzZWMuZGUvb2NzcHIwOgYIKwYB
BQUHMAKGLmh0dHA6Ly9wa2kwMzM2LnRlbGVzZWMuZGUvY3J0L0RUX1JPT1RfQ0Ff
Mi5jZXIwDQYJKoZIhvcNAQELBQADggEBAGMgKP2cIYZyvjlGWTkyJbypAZsNzMp9
QZyGbQpuLLMTWXWxM5IbYScW/8Oy1TWC+4QqAUm9ZrtmL7LCBl1uP27jAVpbykNj
XJW24TGnH9UHX03mZYJOMvnDfHpLzU1cdO4h8nUC7FI+0slq05AjbklnNb5/TVak
7Mwvz7ehl6hyPsm8QNZapAg91ryCw7e3Mo6xLI5qbbc1AhnP9TlEWGOnJAAQsLv8
Tq9uLzi7pVdJP9huUG8sl5bcHUaaZYnPrszy5dmfU7M+oS+SqdgLxoQfBMbrHuif
fbV7pQLxJMUkYxE0zFqTICp5iDolQpCpZTt8htMSFSMp/CzazDlbVBc=
-----END CERTIFICATE-----

-----BEGIN CERTIFICATE-----
MIIDnzCCAoegAwIBAgIBJjANBgkqhkiG9w0BAQUFADBxMQswCQYDVQQGEwJERTEc
MBoGA1UEChMTRGV1dHNjaGUgVGVsZWtvbSBBRzEfMB0GA1UECxMWVC1UZWxlU2Vj
IFRydXN0IENlbnRlcjEjMCEGA1UEAxMaRGV1dHNjaGUgVGVsZWtvbSBSb290IENB
IDIwHhcNOTkwNzA5MTIxMTAwWhcNMTkwNzA5MjM1OTAwWjBxMQswCQYDVQQGEwJE
RTEcMBoGA1UEChMTRGV1dHNjaGUgVGVsZWtvbSBBRzEfMB0GA1UECxMWVC1UZWxl
U2VjIFRydXN0IENlbnRlcjEjMCEGA1UEAxMaRGV1dHNjaGUgVGVsZWtvbSBSb290
IENBIDIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCrC6M14IspFLEU
ha88EOQ5bzVdSq7d6mGNlUn0b2SjGmBmpKlAIoTZ1KXleJMOaAGtuU1cOs7TuKhC
QN/Po7qCWWqSG6wcmtoIKyUn+WkjR/Hg6yx6m/UTAtB+NHzCnjwAWav12gz1Mjwr
rFDa1sPeg5TKqAyZMg4ISFZbavva4VhYAUlfckE8FQYBjl2tqriTtM2e66foai1S
NNs671x1Udrb8zH57nGYMsRUFUQM+ZtV7a3fGAigo4aKSe5TBY8ZTNXeWHmb0moc
QqvF1afPaA+W5OFhmHZhyJF81j4A4pFQh+GdCuatl9Idxjp9y7zaAzTVjlsB9WoH
txa2bkp/AgMBAAGjQjBAMB0GA1UdDgQWBBQxw3kbuvVT1xfgiXotF2wKsyudMzAP
BgNVHRMECDAGAQH/AgEFMA4GA1UdDwEB/wQEAwIBBjANBgkqhkiG9w0BAQUFAAOC
AQEAlGRZrTlk5ynrE/5aw4sTV8gEJPB0d8Bg42f76Ymmg7+Wgnxu1MM9756Abrsp
tJh6sTtU6zkXR34ajgv8HzFZMQSyzhfzLMdiNlXiItiJVbSYSKpk+tYcNthEeFpa
IzpXl/V6ME+un2pMSyuOoAPjPuCp1NJ70rOo4nI8rZ7/gFnkm0W09juwzTkZmDLl
6iFhkOQxIY40sfcvNUqFENrnijchvllj4PKFiDFT1FQUhXB59C4Gdyd1Lx+4ivn+
xbrYNuSD7Odlt79jWvNGr4GUN9RBjNYj1h7P9WgbRGOiWrqnNVmh5XAFmw4jV5mU
Cm26OWMohpLzGITY+9HPBVZkVw==
-----END CERTIFICATE-----

" > $XDG_CONFIG_HOME/cat_installer/ca.pem
function run_python_script {
PASSWORD=$( echo "$PASSWORD" | sed "s/'/\\\'/g" )
if python << EEE1 > /dev/null 2>&1
import dbus
EEE1
then
    PYTHON=python
elif python3 << EEE2 > /dev/null 2>&1
import dbus
EEE2
then
    PYTHON=python3
else
    PYTHON=none
    return 1
fi

$PYTHON << EOF > /dev/null 2>&1
#-*- coding: utf-8 -*-
import dbus
import re
import sys
import uuid
import os

class EduroamNMConfigTool:

    def connect_to_NM(self):
        #connect to DBus
        try:
            self.bus = dbus.SystemBus()
        except dbus.exceptions.DBusException:
            print("Can't connect to DBus")
            sys.exit(2)
        #main service name
        self.system_service_name = "org.freedesktop.NetworkManager"
        #check NM version
        self.check_nm_version()
        if self.nm_version == "0.9" or self.nm_version == "1.0":
            self.settings_service_name = self.system_service_name
            self.connection_interface_name = "org.freedesktop.NetworkManager.Settings.Connection"
            #settings proxy
            sysproxy = self.bus.get_object(self.settings_service_name, "/org/freedesktop/NetworkManager/Settings")
            #settings intrface
            self.settings = dbus.Interface(sysproxy, "org.freedesktop.NetworkManager.Settings")
        elif self.nm_version == "0.8":
            #self.settings_service_name = "org.freedesktop.NetworkManagerUserSettings"
            self.settings_service_name = "org.freedesktop.NetworkManager"
            self.connection_interface_name = "org.freedesktop.NetworkManagerSettings.Connection"
            #settings proxy
            sysproxy = self.bus.get_object(self.settings_service_name, "/org/freedesktop/NetworkManagerSettings")
            #settings intrface
            self.settings = dbus.Interface(sysproxy, "org.freedesktop.NetworkManagerSettings")
        else:
            print("This Network Manager version is not supported")
            sys.exit(2)

    def check_opts(self):
        self.cacert_file = '${XDG_CONFIG_HOME}/cat_installer/ca.pem'
        self.pfx_file = '${XDG_CONFIG_HOME}/cat_installer/user.p12'
        if not os.path.isfile(self.cacert_file):
            print("Certificate file not found, looks like a CAT error")
            sys.exit(2)

    def check_nm_version(self):
        try:
            proxy = self.bus.get_object(self.system_service_name, "/org/freedesktop/NetworkManager")
            props = dbus.Interface(proxy, "org.freedesktop.DBus.Properties")
            version = props.Get("org.freedesktop.NetworkManager", "Version")
        except dbus.exceptions.DBusException:
            version = "0.8"
        if re.match(r'^1\.', version):
            self.nm_version = "1.0"
            return
        if re.match(r'^0\.9', version):
            self.nm_version = "0.9"
            return
        if re.match(r'^0\.8', version):
            self.nm_version = "0.8"
            return
        else:
            self.nm_version = "Unknown version"
            return

    def byte_to_string(self, barray):
        return "".join([chr(x) for x in barray])


    def delete_existing_connections(self, ssid):
        "checks and deletes earlier connections"
        try:
            conns = self.settings.ListConnections()
        except dbus.exceptions.DBusException:
            print("DBus connection problem, a sudo might help")
            exit(3)
        for each in conns:
            con_proxy = self.bus.get_object(self.system_service_name, each)
            connection = dbus.Interface(con_proxy, "org.freedesktop.NetworkManager.Settings.Connection")
            try:
               connection_settings = connection.GetSettings()
               if connection_settings['connection']['type'] == '802-11-wireless':
                   conn_ssid = self.byte_to_string(connection_settings['802-11-wireless']['ssid'])
                   if conn_ssid == ssid:
                       connection.Delete()
            except dbus.exceptions.DBusException:
               pass

    def add_connection(self,ssid):
        server_alt_subject_name_list = dbus.Array({'DNS:wwwmail.uni-duesseldorf.de'})
        server_name = 'wwwmail.uni-duesseldorf.de'
        if self.nm_version == "0.9" or self.nm_version == "1.0":
             match_key = 'altsubject-matches'
             match_value = server_alt_subject_name_list
        else:
             match_key = 'subject-match'
             match_value = server_name

        s_con = dbus.Dictionary({
            'type': '802-11-wireless',
            'uuid': str(uuid.uuid4()),
            'permissions': ['user:$USER'],
            'id': ssid
        })
        s_wifi = dbus.Dictionary({
            'ssid': dbus.ByteArray(ssid.encode('utf8')),
            'security': '802-11-wireless-security'
        })
        s_wsec = dbus.Dictionary({
            'key-mgmt': 'wpa-eap',
            'proto': ['rsn',],
            'pairwise': ['ccmp',],
            'group': ['ccmp', 'tkip']
        })
        s_8021x = dbus.Dictionary({
            'eap': ['ttls'],
            'identity': '$USER_NAME',
            'ca-cert': dbus.ByteArray("file://{0}\0".format(self.cacert_file).encode('utf8')),
             match_key: match_value,
            'password': '$PASSWORD',
            'phase2-auth': 'pap',
            'anonymous-identity': 'anonymous@hhu.de',
        })
        s_ip4 = dbus.Dictionary({'method': 'auto'})
        s_ip6 = dbus.Dictionary({'method': 'auto'})
        con = dbus.Dictionary({
            'connection': s_con,
            '802-11-wireless': s_wifi,
            '802-11-wireless-security': s_wsec,
            '802-1x': s_8021x,
            'ipv4': s_ip4,
            'ipv6': s_ip6
        })
        self.settings.AddConnection(con)

    def main(self):
        self.check_opts()
        ver = self.connect_to_NM()
        self.delete_existing_connections('eduroam')
        self.add_connection('eduroam')

if __name__ == "__main__":
    ENMCT = EduroamNMConfigTool()
    ENMCT.main()
EOF
}
function create_wpa_conf {
cat << EOFW >> $XDG_CONFIG_HOME/cat_installer/cat_installer.conf

network={
  ssid="eduroam"
  key_mgmt=WPA-EAP
  pairwise=CCMP
  group=CCMP TKIP
  eap=TTLS
  ca_cert="${XDG_CONFIG_HOME}/cat_installer/ca.pem"
  identity="${USER_NAME}"
  domain_suffix_match="wwwmail.uni-duesseldorf.de"
  phase2="auth=PAP"
  password="${PASSWORD}"
  anonymous_identity="anonymous@hhu.de"
}
EOFW
chmod 600 $XDG_CONFIG_HOME/cat_installer/cat_installer.conf
}
#prompt user for credentials
  user_cred
  if run_python_script ; then
   show_info "Installation successful"
else
   show_info "Network Manager configuration failed, generating wpa_supplicant.conf"
   if ! ask "Network Manager configuration failed, but we may generate a wpa_supplicant configuration file if you wish. Be warned that your connection password will be saved in this file as clear text." "Write the file" 1 ; then exit ; fi

if [ -f $XDG_CONFIG_HOME/cat_installer/cat_installer.conf ] ; then
  if ! ask "File $XDG_CONFIG_HOME/cat_installer/cat_installer.conf exists; it will be overwritten." "Continue" 1 ; then confirm_exit; fi
  rm $XDG_CONFIG_HOME/cat_installer/cat_installer.conf
  fi
   create_wpa_conf
   show_info "Output written to $XDG_CONFIG_HOME/cat_installer/cat_installer.conf"
fi