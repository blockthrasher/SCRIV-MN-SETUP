# SCRIV-MN-SETUP
Fully automated SCRIV masternode setup script

1. Generate your Masternode Private Key with your QT wallet. 

	In the menu, click on Tools > Debug Console and then enter,

	masternode genkey

	Into the input field. This will generate your private key. 	

	Write this down or copy it somewhere safe.

3. Send 100,000 SCRIV to an address that you generate via the "Receive" > "Request Payment" feature.

4. Use the Debug Console to view your Output, enter:

	masternode outputs

	Write this down or copy it somewhere safe.(Note you may have to wait for 6+ confirmations before the output will become available.

6. SSH (Putty Suggested) to your VPS, login to root, and clone the Github repository:

	git clone https://github.com/blockthrasher/SCRIV-MN-SETUP

7. Navigate to the install folder:

	cd SCRIV-MN-SETUP

8.Install & configure your master node

	bash install_ubuntu_16.04.sh

9. When the script asks, input your VPS IP Address and Private Key (You can copy your private key and paste into the VPS if connected with Putty by right clicking)

NOTE: When the setup is complete, the VPS will ask you to start your masternode in the local wallet.

10. In appdata/roaming/Northern, open up masternode.conf Insert as a new line the following:

	masternodename ipaddress:7979 privatekey output
	
11. Now, launch your local wallet. After launch and synchronization, go to the Masternodes tab. You will see your masternode with “MISSING” status. Right-click it and press Start alias -> Confirm by clicking Yes -> If everything is set up correctly, you will receive a “Successfully started masternode” message -> Hit “OK”.

12. You're all done!

Now you just need to wait for the VPS to sync up the blockchain and await your first masternode payment.



