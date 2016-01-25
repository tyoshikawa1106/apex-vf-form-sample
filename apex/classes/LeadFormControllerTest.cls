@isTest
private class LeadFormControllerTest {

    private static User testAdminUser = new User(Id = UserInfo.getUserId());

    /**
     * コンストラクタ
     */
    static testMethod void LeadFormControllerTest1() {
        
        System.runAs(testAdminUser) {

            Test.startTest();
            
            LeadFormController cls = new LeadFormController();
            
            Test.stopTest();

            System.assertEquals(String.isEmpty(cls.lead.Id), true);
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
            
            LeadFormController cls = new LeadFormController();
            PageReference result = cls.doConfirmation();
            
            Test.stopTest();

            System.assertEquals(result.getUrl(), Page.LeadFormConfirmation.getUrl());
            System.assertEquals(cls.isCorrect, true);
        }
    }

    /**
     * 修正ボタン
     */
    static testMethod void doBackTest1() {
        
        System.runAs(testAdminUser) {

            Test.startTest();
            
            LeadFormController cls = new LeadFormController();
            cls.fileName = 'Sample.xls';

            PageReference result = cls.doBack();
            
            Test.stopTest();

            System.assertEquals(result.getUrl(), Page.LeadForm.getUrl());
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
            
            LeadFormController cls = new LeadFormController();
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
            
            LeadFormController cls = new LeadFormController();
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
            
            LeadFormController cls = new LeadFormController();
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
            
            LeadFormController cls = new LeadFormController();
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
            
            LeadFormController cls = new LeadFormController();
            cls.isCorrect = true;
            cls.uploadFile = Blob.valueOf('Test File');
            cls.fileSize = 1242880;
            cls.fileName = 'sample.xls';
            // リード情報
            cls.lead.LastName = 'Yoshikawa';
            cls.lead.Company = 'T.Yoshikawa Labs';
            // 保存ボタン処理
            PageReference result = cls.doSave();
            
            Test.stopTest();

            System.assertEquals(result.getUrl(), Page.LeadFormThanks.getUrl());
        }
    }
    
    /**
     * 完了ボタン
     * 異常系
     */
    static testMethod void doComplateTest1() {
        
        System.runAs(testAdminUser) {
            
            LeadFormController cls = new LeadFormController();
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
            LeadFormController cls = new LeadFormController();
            cls.isCorrect = true;
            cls.uploadFile = Blob.valueOf('Test File');
            cls.fileSize = 1242880;
            cls.fileName = 'sample.xls';
            // リード情報
            cls.lead.LastName = 'Yoshikawa';
            cls.lead.Company = 'T.Yoshikawa Labs';
            // 保存ボタン処理
            PageReference saveUrl = cls.doSave();

            Test.startTest();
            
            PageReference result = cls.doComplate();
            
            Test.stopTest();

            System.assertEquals(result.getUrl(), new PageReference('/' + cls.lead.Id).getUrl());
        }
    }
}