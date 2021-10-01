import { LightningElement, api, track } from 'lwc';

export default class AccountsTable extends LightningElement {
    @api accounts;
    @api fields;
    @track error;
    isViewAction;

    handleAccountSelect(evt) {
        const event = new CustomEvent('accountselected', {
            detail: evt.detail
        });

        console.log(evt.detail);
        this.dispatchEvent(event);
    }

    prepareRecords(newAccounts) {
        return newAccounts.map((account, index) => ({
            ...account,
            index,
            dataTableValue: this.fields.map((field, fIndex) => this.changeRecordValues(
                account, field.value, fIndex
            ))
        }));
    }

    changeRecordValues(account, fieldName, index) {
        return {
            key: index,
            value: account[fieldName],
            fieldName,
            isViewAction: fieldName === "View"
        };
    }
}