import { LightningElement, api, track } from 'lwc';


export default class AccountsTable extends LightningElement {
    @track error;
    @track nAccounts;
    @track fields;

    @api
    get accounts() {
        return this.nAccounts;
    }

    set accounts(value) {
        this.nAccounts = value && value.accounts && value.fieldSet ? this.prepareRecords(value) : [];
        this.fields = value && value.fieldSet ? value.fieldSet : [];
    }

    handleAccountSelect(evt) {
        const event = new CustomEvent('accountselected', {
            detail: evt.target.getAttribute("data-view-id")
        });

        this.dispatchEvent(event);
    }

    prepareRecords(newAccounts) {
        return newAccounts.accounts.map((account, Index) => ({
            ...account,
            Index,
            dataTableValue: newAccounts.fieldSet.map((field, fieldName) => this.changeRecordValues(
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