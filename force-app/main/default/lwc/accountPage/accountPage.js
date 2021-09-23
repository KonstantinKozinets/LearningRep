import { LightningElement, api } from 'lwc';
import getAccountList from '@salesforce/apex/AccountFieldSet.getAccountList';

export default class AccountPage extends LightningElement {

    @api accounts;
    @api fields;
    @api isAccountCreate;
    @api isAccounts;
    @api selectedAccountId;

    handleAccountSelected(evt) {
        this.selectedAccountId = evt.detail;
        this.isAccounts = false;
    }

    handleAccountCreate() {
        this.isAccounts = false;
        this.isAccountCreate = true;
    }

    handleLoad () {
        getAccountList({ fakeSt: "null" })
        .then(result => {
            this.accounts = result.accounts;
            this.fields = result.fieldSet;
            this.isAccounts = true;
            this.isAccountCreate = false;

            const toastEvent = new ShowToastEvent({
                title: "Success",
                message: "Records are loaded",
                variant: "success"
            });
            this.dispatchEvent(toastEvent);
        })
        .catch(error => {
            this.error = error;
            const toastEvent = new ShowToastEvent({
                title: "Error",
                message: "Error",
                variant: "error"
            });
            this.dispatchEvent(toastEvent);
        });
    }
}