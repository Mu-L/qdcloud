#!/bin/bash

source head.sh

user_name=$1
user_id=$($mysqllogin "select user_id from lab_user where user_name='$user_name'" | grep -v user_id)
vmrip=$(num2ip $(echo $vmrbase + $user_id*4 - 2 | bc))

rm -rf $hpvdiskdir/$user_name
mkdir -p $hpvdiskdir/$user_name/pod
cp -r yml/template/*.yml $hpvdiskdir/$user_name/
sed -i "s/__user_vmr/$vmrip/g" $hpvdiskdir/$user_name/*.yml
sed -i "s/__user_name/$user_name/g" $hpvdiskdir/$user_name/*.yml

echo "### create gateway pod ..."
kubectl apply -f $hpvdiskdir/$user_name/vpc-subnet.yml
kubectl apply -f $hpvdiskdir/$user_name/gateway.yml
kubectl apply -f $hpvdiskdir/$user_name/nat.yml

echo "### get gateway pod node ..."
gwnode=""
while true; do
  gwnode=$($ksys get pod/$gwprefix-$user_name-0 -o yaml | grep nodeName | awk '{print $2}')
  test -n "$gwnode" && break
done

$ksys get pod/vpc-nat-gw-gateway-$user_name-0 -o wide

echo "### create yml(not create pod) on $gwnode"
for vm in ${vmList[@]}; do
  vmname=$(echo $vm | sed "s/jx-//g" | sed "s/^/$user_name-/g")
  ipaddr="10.10.10.$(echo $vm | awk -F "-" '{print $NF}')"
  cp $hpvdiskdir/$user_name/pod.yml $hpvdiskdir/$user_name/pod/$vmname.yml 
  sed -i "s/__vmname/$vmname/g" $hpvdiskdir/$user_name/pod/$vmname.yml
  sed -i "s/__fix_ipaddress/$ipaddr/g" $hpvdiskdir/$user_name/pod/$vmname.yml
  sed -i "s/__select_node/$gwnode/g" $hpvdiskdir/$user_name/pod/$vmname.yml
  echo "create $hpvdiskdir/$user_name/pod/$vmname.yml"
done