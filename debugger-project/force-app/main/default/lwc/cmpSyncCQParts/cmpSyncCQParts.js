import { LightningElement, track, api } from 'lwc';
import syncPartsMethod from '@salesforce/apex/PartSyncController.syncParts';

export default class CheckboxExample extends LightningElement {
    @track isChecked = false;

    handleCheckboxChange(event) {
        this.isChecked = event.target.checked;

        // Call the Apex method when the checkbox is clicked
        if (this.isChecked) {
            this.syncParts();
        }
    }

    syncParts() {
        syncPartsMethod()
            .then(result => {
                // Handle the result if needed
                console.log(result.data);
                if(result == 'success'){
                    alert('success');
                }else{
                    alert('failed');
                }
            })
            .catch(error => {
                // Handle errors
                 alert('failed');
            });
    }
}