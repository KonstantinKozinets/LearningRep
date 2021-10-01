import { LightningElement, api } from 'lwc';

export default class AccountDetail extends LightningElement {
    @api fields;
    @api account;
    _accountId = undefined;

    set accountId(value) {
        this.accountId = value;
        this.account = accounts.find(account => account.Id === value);
    }

    @api get accountId(){
        return this.accountId;
    }

    handleButtonBackClick(evt) {
        const event = new CustomEvent('buttonBackClick', {
            detail: evt.detail
        });

        this.dispatchEvent(event);
    }
}