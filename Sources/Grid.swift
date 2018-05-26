//
//  Grid.swift
//  TinyComponent
//
//  Created by Roy Hsu on 2018/4/10.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - Grid

public struct Grid {
    
    /// The number of columns must be greater than or equal to 1.
    public var columns: Int
    
    /// The number of rows must be greater than or equal to 1.
    public var rows: Int
    
    public init(
        columns: Int,
        rows: Int
    ) {
        
        if columns < 1 { fatalError("The number of columns must be greater than or equal to 1.") }
        
        if rows < 1 { fatalError("The number of rows must be greater than or equal to 1.") }
        
        self.columns = columns
        
        self.rows = rows
        
    }
    
}
