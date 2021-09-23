import { LightningElement, api } from 'lwc';

export default class AccountDetail extends LightningElement {
    @api isAccounts;
    @api isAccountCreate;
    @api fields;
    @api account;
    _accountId = undefined;

    @api get validateCondition() { return (isAccounts == 'false' && isAccountCreate == 'false');}

    set accountId(value) {
        this.accountId = value;
        this.account = accounts.find(account => account.Id === value);
    }

    @api get accountId(){
        return this.accountId;
    }

    handleBack() {
        isAccounts = true;
        isAccountCreate = false;
    }
}