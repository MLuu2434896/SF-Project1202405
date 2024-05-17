/**
    This class allows the option to lock and unlock a record based on the record id.
*/

public class LockLead {
    @InvocableMethod
    public static void lock( List<ID> leadRecordIDs ){
        if( leadRecordIDs.size()  == 0 ){
            return;
        }
        
        List<Lead> leadsToLock = new List<Lead>();
        
        Lead curLead = [ SELECT Id FROM Lead WHERE Id= :leadRecordIDs[0] LIMIT 1 ];
    
        leadsToLock.add( curLead );
        
        // Locks all the lead records using their ids.
        List<Approval.LockResult> lockResults = Approval.lock( leadsToLock, false );
        
        // Handle results & errors.
        for( Approval.LockResult lr : lockResults ){
            if( lr.isSuccess() ){
                System.debug( 'Successfully locked account with ID: ' + lr.getId() );
            }
            else {
                for( Database.Error error : lr.getErrors() ){
                    System.debug( 'The following error has occurred.' );
                    System.debug( error.getStatusCode() + ': ' + error.getMessage() );
                    System.debug( 'Account fields that affected this error: ' + error.getFields() );
                }
            }
        }
    }
    
}