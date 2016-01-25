@isTest
private class ContactFormControllerTest {

    private static User testAdminUser = new User(Id = UserInfo.getUserId());

    /**
     * コンストラクタ
     */
    static testMethod void ContactFormControllerTest1() {
        
        System.runAs(testAdminUser) {

            Test.startTest();
            
            ContactFormController cls = new ContactFormController();
            
            Test.stopTest();

            System.assertEquals(String.isEmpty(cls.contact.Id), true);
            System.assertEquals(cls.isCorrect, false);
            System.assertEquals(String.isEmpty(cls.fileName), true);
            System.assertEquals(cls.uploadFile, null);
            System.assertEquals(cls.fileSize, null);
        }
    }

    /**
     * 次へボタン
     */
    static testMethod void doConfirmationTest1() {
        
        System.runAs(testAdminUser) {

            Test.startTest();
            
            ContactFormController cls = new ContactFormController();
            PageReference result = cls.doConfirmation();
            
            Test.stopTest();

            System.assertEquals(result.getUrl(), Page.ContactFormConfirmation.getUrl());
            System.assertEquals(cls.isCorrect, true);
        }
    }

    /**
     * 修正ボタン
     */
    static testMethod void doBackTest1() {
        
        System.runAs(testAdminUser) {

            Test.startTest();
            
            ContactFormController cls = new ContactFormController();
            cls.fileName = 'Sample.xls';

            PageReference result = cls.doBack();
            
            Test.stopTest();

            System.assertEquals(result.getUrl(), Page.ContactForm.getUrl());
            System.assertEquals(String.isEmpty(cls.fileName), true);
        }
    }

    /**
     * 保存ボタン
     * 不正な操作チェックエラー
     */
    static testMethod void doSaveTest1() {
        
        System.runAs(testAdminUser) {

            Test.startTest();
            
            ContactFormController cls = new ContactFormController();
            cls.isCorrect = false;
            // 保存ボタン処理
            PageReference result = cls.doSave();
            
            Test.stopTest();

            System.assertEquals(result, null);
        }
    }

    /**
     * 保存ボタン
     * ファイル選択チェックエラー
     */
    static testMethod void doSaveTest2() {
        
        System.runAs(testAdminUser) {

            Test.startTest();
            
            ContactFormController cls = new ContactFormController();
            cls.isCorrect = true;
            cls.uploadFile = null;
            // 保存ボタン処理
            PageReference result = cls.doSave();
            
            Test.stopTest();

            System.assertEquals(result, null);
        }
    }

    /**
     * 保存ボタン
     * ファイルサイズチェックエラー
     */
    static testMethod void doSaveTest3() {
        
        System.runAs(testAdminUser) {

            Test.startTest();
            
            ContactFormController cls = new ContactFormController();
            cls.isCorrect = true;
            cls.uploadFile = Blob.valueOf('Test File');
            cls.fileSize = 1242880 + 1;
            // 保存ボタン処理
            PageReference result = cls.doSave();
            
            Test.stopTest();

            System.assertEquals(result, null);
        }
    }

    /**
     * 保存ボタン
     * ファイル拡張子チェックエラー
     */
    static testMethod void doSaveTest4() {
        
        System.runAs(testAdminUser) {

            Test.startTest();
            
            ContactFormController cls = new ContactFormController();
            cls.isCorrect = true;
            cls.uploadFile = Blob.valueOf('Test File');
            cls.fileSize = 1242880;
            cls.fileName = '';
            // 保存ボタン処理
            PageReference result = cls.doSave();
            
            Test.stopTest();

            System.assertEquals(result, null);
        }
    }
    
    /**
     * 保存ボタン
     * エラーなし
     */
    static testMethod void doSaveTest5() {
        
        System.runAs(testAdminUser) {

            Test.startTest();
            
            ContactFormController cls = new ContactFormController();
            cls.isCorrect = true;
            cls.uploadFile = Blob.valueOf('Test File');
            cls.fileSize = 1242880;
            cls.fileName = 'sample.xls';
            // 取引先責任者情報
            cls.contact.LastName = 'Yoshikawa';
            // 保存ボタン処理
            PageReference result = cls.doSave();
            
            Test.stopTest();

            System.assertEquals(result.getUrl(), Page.ContactFormThanks.getUrl());
        }
    }
    
    /**
     * 完了ボタン
     * 異常系
     */
    static testMethod void doComplateTest1() {
        
        System.runAs(testAdminUser) {
            
            ContactFormController cls = new ContactFormController();
            cls.isCorrect = false;

            Test.startTest();
            
            PageReference result = cls.doComplate();
            
            Test.stopTest();

            System.assertEquals(result, null);
        }
    }
    
    /**
     * 完了ボタン
     * 正常系
     */
    static testMethod void doComplateTest2() {
        
        System.runAs(testAdminUser) {
            
            // コンストラクタ
            ContactFormController cls = new ContactFormController();
            cls.isCorrect = true;
            cls.uploadFile = Blob.valueOf('Test File');
            cls.fileSize = 1242880;
            cls.fileName = 'sample.xls';
            // 取引先責任者情報
            cls.contact.LastName = 'Yoshikawa';
            // 保存ボタン処理
            PageReference saveUrl = cls.doSave();

            Test.startTest();
            
            PageReference result = cls.doComplate();
            
            Test.stopTest();

            System.assertEquals(result.getUrl(), new PageReference('/' + cls.contact.Id).getUrl());
        }
    }
}