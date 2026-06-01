# Porting OneUI ROM Guide

A complete OneUI ROM Porting Guide Noob Friendly✅

- ⚠️ If you are too lazy to read all of this, give up or wait for a dev to actually port a ROM for you!

# ✨ Special Thanks

**Huge thanks to these people:**

- **@ShaDisNX255** for his guide!

- **@furbanoramos24** for explaining me some stuff about SELinux!

- **@salvogiangri and collaborators** for UN1CA, which gave me the knowledge to learn how to port!

# ⚙️ Tutorial
## 1. Unpacking 🪄

- Extract the stock ROM zip from your device and the ported device with an Android Kitchen like CRB.

- Replace all the files indicated in the replaced-apps.txt: [replaced_files.txt](https://github.com/Aflaungos/M23Ultra/blob/Android16/replaced_files.txt) in the ported device system folder (should be under `CRB_Folder/Projects/<YOUR_PROJECT_NAME>/ROM)`

- [OPTIONAL/DEBLOATING] Open [removed_apps.txt](https://github.com/Aflaungos/M23Ultra/blob/Android16/removed_apps.txt) and delete all the apps in the list.

⚠️ Some files are missing in your `vendor` partition because they don't come with non-flagship phones. They are unessential, but if you want full compatibility and working features, you should compare your `vendor` parition with the ported device's `vendor` partition.

## 1.1 Fixing system_ext 🛠️

- Check if your system_ext folder is outside or inside /system. If you have system_ext as a partition inside super then it is outside system. In either case, you have to place the folder in the proper position and also add the symlink for each case:

  1. When system_ext is a super partition, place system_ext folder at `/system` and create a symlink inside `/system/system` called `system_ext` that links to the path `/system/system/system_ext`

  2. When system_ext is NOT a super partition, place system_ext folder at `/system/system` and create a symlink inside `/system` called `system_ext` that links to the path `/system/system_ext`

  3. You need to also fix `file_contexts` for the system. Open up `system_file_contexts` and Add the `system_ext` entries from port rom's `system_ext_file_contexts`. Check your device's rom `system_file_contexts` and compare to make sure the same entries are there, aside from the new entries of the port system_ext.

## 2. Inside the `system_ext` partition of the ported device

  - [OPTIONAL] Check if any 'FM radio' libs are missing and port them from your device to it.

  - Replace the build.prop file with your device's file inside the `etc` folder.

  - Inside `system_ext/etc/selinux`, follow these steps to fix SELinux based on the OneUI version:

    1. Check `plat_sepolicy_vers.txt` for which vndk version you have (ex: 30 = VNDK30, 31 = VNDK31 and so on). Note the number down as `YOURNUMBER`.

    2. Inside `vendor/etc/selinux/plat_pub_versioned.cil`, check with each line in the table below if you have it on this file, **and if not** add all lines containing these entries into `vendor/etc/selinux/plat_pub_versioned.cil` and `vendor/etc/selinux/vendor_sepolicy.cil`
    
    3. These are the entries:

      OneUI 5/5.1              | OneUI 6/6.1/6.1.1             | OneUI 7              | OneUI 8/8.5
      |:----------------------:|:-----------------------------:|:--------------------:|:--------------------:|
      audiomirroring           | hal_dsms_default              | attiqi_app           | heatmap_default		           
      audiomirroring_exec      | hal_dsms_default_exec         | attiqi_app_data_file | heatmap_default_exec		       
      audiomirroring_service   | proc_compaction_proactiveness | ker_app              | -------------------- 
      fabriccrypto             | sbauth               | kpp_app              | -------------------- 
      fabriccrypto_exec        | sbauth_exec          | kpp_data_file        | -------------------- 
      fabriccrypto_data_file   | -------------------- | -------------------- | -------------------- 
      hal_dsms_service         | -------------------- | -------------------- | -------------------- 
      uwb_regulation_skip_prop | -------------------- | -------------------- | --------------------

      - ⚠️ They stack with higher OneUI version, so if for example you're on UI 7, check from 5 and 6 too!
      - ⚠️ If you wish to skip this step and build with SELinux disabled (which I strongly do not recommend, edit the line `ro.build.selinux=1` to `ro.build.selinux=0` inside `system/build.prop`. You might also need to patch kernel bootargs)

## 3. `system_ext`: Fixing APEX

  - If comparing inside the folder `system_ext/apex` from port and your device ROM, you notice that you have a different number (which is the VNDK version of your device) you have to replace it with yours.
    |- For example, `com.android.vndk.v30.apex` is yours and `com.android.vndk.v31/32/33/34.apex` in the port, replace it!

  - If you face `vold-failed` as reboot reason in logs, just check which apex it says missing and add it.

## 4. Inside `system_dlkm/etc` folder

  - Replace the build.prop file from with your device's file.

## 5. Inside the `system` partition of the ported device:

  - Replace the `build.prop` file from ported device `system` partition with your device's files.

  - [OPTIONAL] Inside the `priv-app` folder, copy over from the repo Applock, wallpaper-res (optional) and SSecure.

  - [OPTIONAL] Replace HybridRadio with your device's if you care about radio.

  - [OPTIONAL] Inside the `lib` and `lib64` folders, copy over FM radio files from your device's.

  - [OPTIONAL] Copy over the FM radio and Applock permissions from your device to ported device's `system` partition.

  - [OPTIONAL] Copy over the `default-permissions` folder from your device to ported device's `system` partition.

  - [OPTIONAL] Inside the `app` folder, copy over all Gallery related folders from the repo to your system. Copy over FunModeSDK from your device to ported device's `system/app` folder.

## 6. Packaging 💾📀

- After completing all the changes you want, re-pack `odm`, `product` and `vendor` from your device's project as `raw`.

- Re-pack `system` (again as `raw`) from ported device's project, and copy over the newly generated `system.img` file to your device's project Build folder.

- Repack `super.img` as a `sparse` image inside device's project and compress the new `super.img` into an `xz` file using 7-zip

## 7. Troubleshooting packaging

- If you get a out of space error during packaging a partition or super, be sure to debloat it using CRB or inside app/priv-app! I like to use Spacesniffer to see exactly which programs are the biggest in size and if possible remove them. Do not delete any app as some of them are important for the ROM to work, do a research on each app!

- As for SELinux_fs errors, open your `project folder` and inside `config` folder open `system_file_contexts.txt` from port and your ROM. Check the error related line and find it in the txt file of your ROM and copy it to the port txt file. If the line disappears you have done it correctly, continue until no lines appear!

## 8. Installing ⬇️

- Extract super.img from xz file and flash using TWRP or any other custom recovery as image file in `Super` Partition

## 9. Done 🎉

- **Congratulations! You have finished this guide, and should probably have a working OneUI port. Now you'll have to fix bugs, good luck!**
