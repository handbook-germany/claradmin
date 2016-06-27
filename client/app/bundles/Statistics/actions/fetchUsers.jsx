import fetch from 'isomorphic-fetch'

const fetchStatisticsRequest = function() {
  return {
    type: 'FETCH_USERS_REQUEST'
  }
}
const fetchStatisticsFailure = function(error) {
  return {
    type: 'FETCH_USERS_FAILURE',
    error
  }
}
const fetchStatisticsSuccess = function(response) {
  return {
    type: 'FETCH_USERS_SUCCESS',
    response
  }
}
export default function fetchStatistics() {
  return function(dispatch) {
    dispatch(fetchStatisticsRequest())

    return fetch('/api/v1/users.json')
      .then(
        function(response) {
          const { status, statusText } = response
          if (status >= 400) {
            dispatch(fetchStatisticsFailure(response))
            throw new Error(`Fetch Users Error ${status}: ${statusText}`)
          }
          return response.json()
        }
      ).then(json => {
        console.log('fetchUsers json', json)
        dispatch(fetchStatisticsSuccess(json))
      })
  }
}

 fetchStatistics
