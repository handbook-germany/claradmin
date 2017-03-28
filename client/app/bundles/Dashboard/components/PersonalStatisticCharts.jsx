import React, { PropTypes, Component } from 'react'
<<<<<<< HEAD
import StatisticsChartsAndData from '../../StatisticsChartsAndData/containers/StatisticsChartsAndData'
=======
import BurnUpChartContainer from '../../ShowStatisticChart/containers/BurnUpChartContainer'
import CollapsiblePanel from '../../CollapsiblePanel/containers/CollapsiblePanel'
>>>>>>> develop

export default class PersonalStatisticCharts extends Component {
  componentDidMount() {
    this.props.loadData()
  }

  render() {
    const {
      statisticCharts
    } = this.props

    return (
      <CollapsiblePanel
        title='Meine W&A Statistiken' identifier='personal-statistic-charts'
        visible={false}
        content={
          statisticCharts.map(chart => {
            return(
              <div key={chart.id} className="chart">
                <h4>{chart.title}</h4>
                <StatisticsChartsAndData statisticChart={chart} />
                <hr />
              </div>
            )
          })
        }
      />
    )
  }
}
