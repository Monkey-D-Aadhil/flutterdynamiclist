enum DataSourceType {
  RestApi,
  Connector,
  Query,
  Entity,
  RestAPIConnector,
  SQLConnector;

  int get intValue => index + 1;
}
