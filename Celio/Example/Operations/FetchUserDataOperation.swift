//
//  FetchUserDataOperation.swift
//  Celio
//
//  Created by MP-11 on 01/08/18.
//  Copyright © 2018 Jatin. All rights reserved.
//

import Foundation

class FetchUserDataOperation: CGroupOperation {

    init(operations: [Operation], completion: @escaping (JPSampleResponseDataModel) -> Void) {
        let networkOperation = CNetworkOperation(networkRequest: APIRouter.getData())
        let parseOperation = CParseDataOperation<JPSampleResponseDataModel>()
        let adapter = BlockOperation { [unowned parseOperation, unowned networkOperation] in
            parseOperation.dataFetched = networkOperation.dataFetched
        }
        let finishingOperation = BlockOperation { [unowned parseOperation] in
            if let parsedModel = parseOperation.parsedData {
                completion(parsedModel)
            }
        }

        adapter.addDependency(networkOperation)
        parseOperation.addDependency(adapter)
        finishingOperation.addDependency(parseOperation)

        super.init(operations: [networkOperation, parseOperation, adapter])
    }

    override func operationDidFinish(operation: Operation, withErrors errors: [NSError]) {
        print("Fetching complete")
        print("Errors")
        for err in errors {
            print(err)
        }
    }
}
