//
//  MateriallResult.swift
//  Materiall
//
//  Created by Prasenjit Das on 15/03/21.
//

import Foundation

/// An asynchrosous request result
///
/// - success: the request did success with an object related
/// - failure: the request did fail with an error
public typealias MateriallResult<T> = Result<T, Error>
