import { LightningElement, api, track } from 'lwc';


export default class AccountsTable extends LightningElement {
    @api accounts;
    @api fields;
    @track error;
    @track nAccounts;

    connectedCallback() {
        this.nAccounts = this.prepareRecords(this.accounts);
    }

    handleAccountSelect(evt) {
        console.log(evt.target.getAttribute("data-view-id"));
        const event = new CustomEvent('accountselected', {
            detail: evt.target.getAttribute("data-view-id")
        });

        this.dispatchEvent(event);
    }

    prepareRecords(newAccounts) {
        console.log('accounts:', this.accounts);
        return newAccounts.map((account, Index) => ({
            ...account,
            Index,
            dataTableValue: this.fields.map((field, fieldName) => this.changeRecordValues(
                account, field.fieldName, fieldName
            ))
        }));
    }

    changeRecordValues(account, fieldName, index) {
        return {
            key: index,
            value: account[fieldName],
            fieldName,
            isViewAction: fieldName === 'Name'
        };
    }
}