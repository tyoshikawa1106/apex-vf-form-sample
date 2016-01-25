public with sharing class ContactFormController {

    private FormHelper helper = new FormHelper();

    // 取引先責任者
    public Contact contact {get; set;}
    // 不正操作チェック
    public Boolean isCorrect {get; set;}
    // ファイル名
    public String fileName {get;set;}
    // ファイルオブジェクト
    public Blob uploadFile {get;set;}
    // ファイルサイズ
    public Long fileSize {get; set;}

    /**
     * コンストラクタ
     */
    public ContactFormController() {
        this.contact = new Contact();
        this.isCorrect = false;
        // ファイル情報初期化
        this.clearSelectFile();
    }

    /**
     * ファイル情報初期化
     */
    public void clearSelectFile() {
        this.fileName = '';
        this.uploadFile = null;
        this.fileSize = null;
    }

    /**
     * 次へボタン
     */
    public PageReference doConfirmation() {
        this.isCorrect = true;
        return Page.ContactFormConfirmation.setRedirect(false);
    }

    /**
     * 修正ボタン
     */
    public PageReference doBack() {
        // ファイル情報初期化
        this.clearSelectFile();
        return Page.ContactForm.setRedirect(false);
    }

    /**
     * 保存ボタン
     */
    public PageReference doSave() {
        Savepoint sp = Database.setSavepoint();
        try {
            // 不正な操作チェック
            Boolean isError = this.helper.checkIsCorrectError(this.isCorrect);
            if (isError) return null;

            // ファイル選択チェック
            if(this.helper.checkIsSelectFileError(this.uploadFile)) return null;

            // ファイルサイズチェック
            if(this.helper.checkIsFileSizeError(this.fileSize)) {
                // ファイル情報初期化
                this.clearSelectFile();
                return null;
            }

            // ファイル拡張子チェック
            if (this.helper.checkFileTypeError(this.fileName)) {
                // ファイル情報初期化
                this.clearSelectFile();
                return null;
            }

            // 取引先責任者情報登録
            Contact dmlContact = this.contact.clone(true, false, true, true);
            insert dmlContact;
            
            // 添付ファイル登録
            Attachment attacment = this.helper.getAttachment(this.fileName, this.uploadFile, dmlContact.Id);
            insert attacment;

            // 取引先責任者に最新情報を反映
            this.contact = dmlContact;

        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            Database.rollback(sp);
            // ファイル情報初期化
            this.clearSelectFile();
            return null;
        }
        
        // ファイル情報初期化
        this.clearSelectFile();
        return Page.ContactFormThanks.setRedirect(false);
    }

    /**
     * 完了ボタン
     */
    public PageReference doComplate() {
        try {
            // 不正な操作チェック
            Boolean isError = this.helper.checkIsCorrectError(this.isCorrect);
            if (isError) return null;
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            // ファイル情報初期化
            this.clearSelectFile();
            return null;
        }
        return new PageReference('/' + this.contact.Id);
    }
}