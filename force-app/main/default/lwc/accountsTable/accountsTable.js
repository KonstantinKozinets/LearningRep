import { LightningElement, api, track } from 'lwc';


export default class AccountsTable extends LightningElement {
    @api accounts;
    @api fields
    @api isAccounts;
    @api isAccountCreate;
    @track error;
    columns = [];

    set fields(value) {
        for (i = 0, len = value.length; i < len; i++) {
            this.columns.push({ label : value[i], name : value[i]});
        }
        this.fields = value;
    }

    get validateCondition() { return (isAccounts == 'true' && isAccountCreate == 'false');}

    handleAccountSelect(evt) {
        const event = new CustomEvent('accountselected', {
            detail: evt.detail
        });

        this.dispatchEvent(event);
    }
}