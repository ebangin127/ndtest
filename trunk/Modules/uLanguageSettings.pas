unit uLanguageSettings;

interface

var
  CurrLang: Integer;

const
  LANG_HANGUL = 0;
  LANG_ENGLISH = 1;

const
  //ĳ�� ����
    ErrCache: Array[0..1] of String = ('���� ��ġ���� �߸��� ĳ�� ������ ��Ÿ�� �����߽��ϴ�', 'Wrong cache setting');

  //����
    CapTotal: Array[0..1] of String = ('��ü �뷮 : ', 'Disk Size : ');
    CapFirmware: Array[0..1] of String = ('�߿��� ���� : ', 'Firmware : ');
    CapSerial: Array[0..1] of String = ('�ø��� ��ȣ : ', 'Serial Number : ');
    CapWriteError: Array[0..1] of String = ('����� ���� (�߿�) : ', 'Erase Errors (Important) : ');
    CapReadError: Array[0..1] of String = ('�б� ���� : ', 'Read Errors: ');
    CapRepSect: Array[0..1] of String = ('ġȯ�� ���� (�߿�) : ', 'Reallocated Sectors (Important) : ');
    CapAlign: Array[0..1] of String = ('��Ƽ�� �迭 (�߿�) : ', 'Partition Align (Important) : ');
    CapNotSafe: Array[0..1] of String = ('���� : ', 'Status : ');

    CapSafe: Array[0..1] of String = ('�����Դϴ�.', 'Safe.');
    CapNotSafeRepSect: Array[0..1] of String = ('SSD�� ������ ��������, SSD ���� �ڷ� ����� ������ �ǰ��մϴ�.', 'There are some errors. PLEASE DO BACKUP!');
    CapBadPartition: Array[0..1] of String = ('��Ƽ���� ��߳�����, ���� 7���� ��Ƽ���� �ٽ� �����ּ���.', 'Partition align error. Re-partition with Win 7 setup tool.');
    CapOldVersion: Array[0..1] of String = (' (������)', ' (Old Version)');

    CapGood: Array[0..1] of String = (': (����) ', ': (Good) ');
    CapBad: Array[0..1] of String = ('K - ��߳�) ', 'K - Bad) ');

  //���� ������
    CapToSeeSerial: Array[0..1] of String = (' (�ø��� ��ȣ ������ Xǥ�� Ŭ��)', ' (To see the serial number, click the ''X'' sign)');


  //���� ��ư
    BtFirmware: Array[0..1] of String = ('�߿���', 'Firmware');
    BtErase: Array[0..1] of String = ('�ʱ�ȭ', 'Erase');
    BtOpt: Array[0..1] of String = ('����ȭ', 'Optimization');
    BtHelp: Array[0..1] of String = ('���� (F1)', 'Help (F1)');
    BtAnaly: Array[0..1] of String = ('��� ���', 'Statistics');
    BtLifeAnaly: Array[0..1] of String = ('���� ���', 'Statistics');
    BtTrim: Array[0..1] of String = ('���� Ʈ��', 'Manual Trim');


  //�߿��� ������Ʈ
    CapFirm: Array[0..1] of String = ('�߿��� ������Ʈ USB �����', 'Firmware Update using USB flash drive');
    CapSelUSB: Array[0..1] of String = ('USB ���� : ', 'USB Drive : ');
    CapNewFirm: Array[0..1] of String = ('�� �߿��� ���� : ', 'Latest firmware : ');
    CapWarnErase: Array[0..1] of String = (' ������ ����, ������ USB ���� ��� �ڷᰡ �����Ǵ� �Ϳ� �����մϴ�.', ' All the data in the drive will be ERASED.');
    BtDoUpdate: Array[0..1] of String = ('�߿��� ������Ʈ USB ���� �����ϱ�', 'Start making a F/W Update USB Drive');
    CapCurrFirm: Array[0..1] of String = ('(���� �߿���� ����)', '(Current Firmware)');

    AlrtNoInternet: Array[0..1] of String = ('���ͳݿ� ������ �Ǿ����� �ʽ��ϴ�.' + Chr(13) + Chr(10) + '���� �� �ٽ� ������ �ּ���.',
                                          'No internet connectivity detected.');
    AlrtStartFormat: Array[0..1] of String = ('USB ������ �����մϴ�. ��ø� ��ٷ��ּ���.', 'Start formatting. Wait please.');
    AlrtStartRecord: Array[0..1] of String = ('USB�� �߿��� �������� ����� �����մϴ�.' + Chr(13) + Chr(10) + 'â�� ���������� ��ٷ��ּ���.'
                                              , 'Start writing firmware update. Please wait.');
    AlrtFirmEnd: Array[0..1] of String = ('���� ������ؼ� �߿��� ������Ʈ�� �������ּ���.', 'Restart and Start updating.');


    CapFirmDwld: Array[0..1] of String = ('�߿��� �ٿ�ε�', 'Downloading Firmware');

    AlrtFirmStart: Array[0..1] of String = ('�߿��� �ٿ�ε带 �����մϴ�.', 'Starting download Firmware.');
    AlrtFirmCanc: Array[0..1] of String = ('�߿��� �ٿ�ε尡 ��ҵǾ����ϴ�.', 'Download has been canceled.');
    AlrtFirmFail: Array[0..1] of String = ('�߿��� �ٿ�ε尡 �����Ͽ����ϴ�.', 'Download has been failed.');


  //�ʱ�ȭ
    CapErase: Array[0..1] of String = ('�ʱ�ȭ USB �����', 'Secure Erase using USB flash drive');
    CapEraDwld: Array[0..1] of String = ('SSD �ʱ�ȭ �� �ٿ�ε�', 'Downloading Secure Erase tool');
    BtDoErase: Array[0..1] of String = ('�ʱ�ȭ USB ���� �����ϱ�', 'Start making a Secure Erase USB Drive');

    AlrtEraStart: Array[0..1] of String = ('SSD �ʱ�ȭ �� �ٿ�ε带 �����մϴ�.', 'Starting download Secure erase tool.');
    AlrtEraEnd: Array[0..1] of String = ('���� ������ؼ� SSD �ʱ�ȭ�� �������ּ���.', 'Restart and Start erasing.');
    AlrtEraCanc: Array[0..1] of String = ('�ʱ�ȭ �� �ٿ�ε尡 ��ҵǾ����ϴ�.', 'Download has been canceled.');
    AlrtEraFail: Array[0..1] of String = ('�ʱ�ȭ �� �ٿ�ε尡 �����Ͽ����ϴ�.', 'Download has been failed.');


  //UNetBootin �ٿ�ε�
    CapBoot: Array[0..1] of String = ('���� ������ USB ���۱� �ٿ�ε�', 'Downloading Bootable USB Drive maker (UNetbootin)');

    AlrtBootStart: Array[0..1] of String = ('USB ��� �� �ٿ�ε带 �����մϴ�.', 'Starting download Bootable USB Drive maker.');
    AlrtBootCanc: Array[0..1] of String = ('USB ��� �� �ٿ�ε尡 ��ҵǾ����ϴ�.', 'Download has been canceled.');
    AlrtBootFail: Array[0..1] of String = ('USB ��� �� �ٿ�ε尡 �����Ͽ����ϴ�.', 'Download has been failed.');


  //����ȭ
    CapNameOpt: Array[0..1] of String = ('SSD ����ȭ', 'SSD Optimization');

    BtDoOpt: Array[0..1] of String = ('����ȭ �����ϱ�', 'Start Optimization');
    BtRollback: Array[0..1] of String = ('����ȭ �ǵ�����', 'Rollback');

    CapAlreadyCompleted: Array[0..1] of String = (' (�̹� �Ϸ��)', ' (Already Completed)');

    CapOptHiber: Array[0..1] of String = ('���̹����̼� ����', 'Disable Hibernation');
    CapOptFilerec: Array[0..1] of String = ('���� ���� ��� ���ֱ�', 'Disable the Last access time attribute');
    CapOptSupFetch: Array[0..1] of String = ('������ġ/������ġ ����', 'Disable the Prefetch/Superfetch Service');

    CapOptPrefetch: Array[0..1] of String = ('������ġ ����', 'Disable the Prefetch Service');
    CapOptIndex: Array[0..1] of String = ('���� ����(����, �뷮 Ȯ��&���� ��� / ���� ã�� ������)', 'Disable the Indexing Service');

    AlrtOptCmpl: Array[0..1] of String = ('����ȭ�� �Ϸ�Ǿ����ϴ�.', 'Optimization has completed.');
    AlrtOptRetCmpl: Array[0..1] of String = ('����ȭ ������ �Ϸ�Ǿ����ϴ�.', 'Rollback operation has completed.');


  //���� Ʈ��
    CapTrimName: Array[0..1] of String = ('���� Ʈ�� (����� �ǰ��մϴ�)', 'Manual Trim (Use at your own risk)');
    CapStartManTrim: Array[0..1] of String = ('���� Ʈ�� �����ϱ�', 'Start manual trim');
    BtSemiAutoTrim: Array[0..1] of String = ('���ڵ� Ʈ�� ����', 'Semi-auto trim');
    CapLocalDisk: Array[0..1] of String = ('���� ��ũ', 'Local Disk');
    CapRemvDisk: Array[0..1] of String = ('�̵��� ��ũ', 'Removable Disk');
    CapProg1: Array[0..1] of String = ('���� ��Ȳ : ', 'Progress : ');
    CapProg2: Array[0..1] of String = ('����̺� Ʈ�� ������', 'Drive trimming');


  //���ڵ� Ʈ��
    CapSemiAutoTrim: Array[0..1] of String = ('���ڵ� Ʈ��', 'Semi-Auto Trim (Use at your own risk)');
    CapSemiAutoTrimExp: Array[0..1] of String = ('���ڵ� Ʈ���̶� 1�� �̻� ���� ���� ���ӽ� Ʈ���� �����ϴ� ����Դϴ�.',
                                                 'Semi-auto trim is the trim setting that does trim after 60 secs of idle time.');
    ChkSemiAutoTrim: Array[0..1] of String = ('�� ����̺꿡 ���ؼ� ���ڵ� Ʈ�� ����', 'Apply semi-auto trim');
    BtRtn: Array[0..1] of String = ('���ư���', 'Return');


  //�̹��� �ٿ�ε�
    CapImgDwld: Array[0..1] of String = ('�ʼ� �̹��� �ٿ�ε�', 'Downloading Essential Image');

    AlrtImgCanc: Array[0..1] of String = ('�̹��� �ٿ�ε尡 ��ҵǾ����ϴ�.', 'Image download has been canceled.');
    AlrtImgFail: Array[0..1] of String = ('�̹��� �ٿ�ε尡 �����Ͽ����ϴ�.', 'Image download has been failed.');


  //���ڵ� Ʈ��
    CapAppDisk: Array[0..1] of String = ('����� ����̺� : ', 'Drives to be applied : ');

  //��� ���
    CapAnaly: Array[0..1] of String = ('SSD ��� ���', 'SSD Statistics');
    CapLifeAnaly: Array[0..1] of String = ('SSD ���� ���', 'SSD Statistics');
    CapNandWrite: Array[0..1] of String = ('���� ���� : ', 'Nand Writes : ');
    CapHostWrite: Array[0..1] of String = ('ȣ��Ʈ ���� : ', 'Host Writes : ');
    CapMylesLeft: Array[0..1] of String = ('���� ���� ���� : ', 'Available Reserved Space : ');
    CapSSDLifeLeft: Array[0..1] of String = ('���� ���� : ', 'SSD Life : ');
    CapWearLevel: Array[0..1] of String = ('���� ������ Ƚ�� : ', 'Wear Leveling Count : ');

    Cap1Month: Array[0..1] of String = ('�ֱ� 30�� ��� : ', 'Average write per day (Recent 30 days) : ');
    Cap3Month: Array[0..1] of String = ('�ֱ� 3���� ��� : ' , 'Average write per day (Recent 3 months) : ');
    Cap6Month: Array[0..1] of String = ('�ֱ� 6���� ��� : ' , 'Average write per day (Recent 6 months) : ');
    Capr1Month: Array[0..1] of String = ('�ֱ� 30�� ��� : ', 'Average replaced sectors per day (Recent 30 days) : ');
    Capr3Month: Array[0..1] of String = ('�ֱ� 3���� ��� : ' , 'Average replaced sectors per day (Recent 3 months) : ');
    Capr6Month: Array[0..1] of String = ('�ֱ� 6���� ��� : ' , 'Average replaced sectors per day (Recent 6 months) : ');
    CapToday: Array[0..1] of String = ('���� ��뷮 : ' , 'Today Usage : ');
    CaprToday: Array[0..1] of String = ('���� ������ ġȯ ���� : ' , 'Replaced Sectors (Today) : ');
    CapPowerTime: Array[0..1] of String = ('������ ���� �ð� : ', 'Total Power-On Hours : ');

    CapDay: Array[0..1] of String = ('��' , 'day');
    CapCount: Array[0..1] of String = ('��' , '');
    CapSec: Array[0..1] of String = ('��' , 'sec');
    CapMin: Array[0..1] of String = ('��' , 'min');
    CapHour: Array[0..1] of String = ('�ð�' , 'hrs');

    CapPortable: Array[0..1] of String = ('���ͺ� ���������� �������� �ʽ��ϴ�.', 'Portable edition doesn''t have this feature.');
    CapNotSupported: Array[0..1] of String = ('������ ��ǰ�Դϴ�', 'Not supported');


  //�ǿø�
    CapCurrVer: Array[0..1] of String = ('������ �� : ' , 'Current version : ');
    CapNewVer: Array[0..1] of String = ('���ο� �� : ' , 'Latest version : ');
    CapUpdQues: Array[0..1] of String = ('���� �ǿø��� �Ͻðڽ��ϱ�?' , 'Would you like to get update?');
    CapUpdDwld: Array[0..1] of String = ('�ǿø� �ٿ�ε�', 'Downloading update');

    AlrtUpdateExit: Array[0..1] of String = ('�� ���α׷��� �ǿø��� ���� ���α׷��� �����մϴ�.', 'Closing the program to do update.');
    AlrtVerCanc: Array[0..1] of String = ('�ǿø� �ٿ�ε尡 ��ҵǾ����ϴ�.', 'Update download has been canceled.');
    AlrtVerTraff: Array[0..1] of String = ('Ʈ������ �ʰ��Ǿ����Ƿ�, ���� �ٿ�޾��ּ���.' + Chr(13) + Chr(10) + '�˼��մϴ�.',
                                            'The update server is over its quota. Try later.' + Chr(13) + Chr(10) + 'Sorry for inconvenience.');
    AlrtNewVer: Array[0..1] of String = ('���ο� �� �߰�' , 'Update available');


  //���� ���� ����
    CapWrongBuf: Array[0..1] of String = ('���� ĳ�� ���� �߸���' , 'has wrong setting');
    CapWrongBuf2: Array[0..1] of String = ('�� �������� SSD���� ���� ���� ĳ�ø� ���� ������' , 'Do NOT turn off write cache on non-sandforce SSDs.');

    CapBck: Array[0..1] of String = ('��� ��� ���' , 'requires BACKUP IMMEDIATELY');
    CapBck2: Array[0..1] of String = ('SSD���� ���� ����' , 'It has dead sector');
    CapOcc: Array[0..1] of String = ('�߻�' , '');


  //���� �޽���
    AlrtNoFirmware: Array[0..1] of String = ('�߿��� ������ �����ϴ�. ���α׷��� �缳ġ���ּ���.', 'There isn''t any Firmware File. Please re-install the tool.');
    AlrtOSError: Array[0..1] of String = ('�� �ü���� �������� �ʴ� �ü��(XP �̸�)�̹Ƿ� �����մϴ�.', 'This tools doesn''t support OS under Windows XP.');
    AlrtNoSupport: Array[0..1] of String = ('SSD�� ������� �ʾҽ��ϴ�.' + Chr(13) + Chr(10) + '�̹���(ebangin127@gmail.com)���� ��ġ�� ��û�غ�����.', 'There is no supported SSD.');
    AlrtNoUSB: Array[0..1] of String = ('USB ������ġ�� �������ּ���.', 'Connect the USB Flash Drive');
    AlrtNoUpdate: Array[0..1] of String = ('�̹� �ֽ� �����Դϴ�.', 'Already your SSD has the latest firmware.');
    AlrtNoCheck: Array[0..1] of String = ('USB �ڷ� �ս� ���� üũ�ڽ��� üũ�� �ּ���.', 'Read and Check the caution.');
    AlrtAutoCopy: Array[0..1] of String = ('- �� ������ �ڵ����� ����˴ϴ� -', '- This message has copied -');


  //�ٿ�ε�
    CapSpeed: Array[0..1] of String = ('���� �ӵ� : ', 'Transfer Speed : ');
    CapTime: Array[0..1] of String = ('���� �ð� : ', 'Remaining time : ');
implementation

end.
