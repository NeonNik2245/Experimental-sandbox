import { useBackend } from "../backend";
import { Button, LabeledList, Box, Section } from "../components";
import { Window } from "../layouts";

export const RequestConsole = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    screen,
  } = data;

  const pickPage = index => {
    switch (index) {
      case 0:
        return <MainMenu />;
      case 1:
        return <DepartmentList purpose="ASSISTANCE" />;
      case 2:
        return <DepartmentList purpose="SUPPLIES" />;
      case 3:
        return <DepartmentList purpose="INFO" />;
      case 4:
        return <MessageResponse type="SUCCESS" />;
      case 5:
        return <MessageResponse type="FAIL" />;
      case 6:
        return <MessageLog type="MESSAGES" />;
      case 7:
        return <MessageAuth />;
      case 8:
        return <StationAnnouncement />;
      case 9:
        return <PrintShippingLabel />;
      case 10:
        return <MessageLog type="SHIPPING" />;
      default:
        return "WE SHOULDN'T BE HERE!";
    }
  };

  return (
    <Window>
      <Window.Content scrollable>
        {pickPage(screen)}
      </Window.Content>
    </Window>
  );
};

const MainMenu = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    newmessagepriority,
    announcementConsole,
    silent,
  } = data;
  let messageInfo;
  if (newmessagepriority === 1) {
    messageInfo = (
      <Box color="red">
        Новые сообщения
      </Box>
    );
  } else if (newmessagepriority === 2) {
    messageInfo = (
      <Box color="red" bold>
        НОВЫЕ ПРИОРИТЕТНЫЕ СООБЩЕНИЯ
      </Box>
    );
  }
  return (
    <Section title="Main Menu">
      {messageInfo}
      <Box mt={2}>
        <Button
          content="Просмотреть сообщения"
          icon={newmessagepriority > 0 ? "envelope-open-text" : "envelope"}
          onClick={
            () => act('setScreen', { setScreen: 6 })
          } />
      </Box>
      <Box mt={2}>
        <Box>
          <Button
            content="Запросить помощь"
            icon="hand-paper"
            onClick={
              () => act('setScreen', { setScreen: 1 })
            } />
        </Box>
        <Box>
          <Button
            content="Запросить припасы"
            icon="box"
            onClick={
              () => act('setScreen', { setScreen: 2 })
            } />
        </Box>
        <Box>
          <Button
            content="Доложить анонимную информацию"
            icon="comment"
            onClick={
              () => act('setScreen', { setScreen: 3 })
            } />
        </Box>
      </Box>
      <Box mt={2}>
        <Box>
          <Button
            content="Распечатать доставочную упаковку"
            icon="tag"
            onClick={
              () => act('setScreen', { setScreen: 9 })
            } />
        </Box>
        <Box>
          <Button
            content="Просмотреть журнал доставки"
            icon="clipboard-list"
            onClick={
              () => act('setScreen', { setScreen: 10 })
            } />
        </Box>
      </Box>
      {!!announcementConsole && (
        <Box mt={2}>
          <Button
            content="Отправить уведомление по станции"
            icon="bullhorn"
            onClick={
              () => act('setScreen', { setScreen: 8 })
            } />
        </Box>
      )}
      <Box mt={2}>
        <Button
          content={silent ? "Диктофон выключен" : "Диктофон включён"}
          selected={!silent}
          icon={silent ? "Звук выключен" : "Звук включён"}
          onClick={
            () => act('toggleSilent')
          } />
      </Box>
    </Section>
  );
};

const DepartmentList = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    department,
  } = data;

  let list2iterate;
  let sectionTitle;
  switch (props.purpose) {
    case "ASSISTANCE":
      list2iterate = data.assist_dept;
      sectionTitle = "Запрос помощи другого департамента";
      break;
    case "SUPPLIES":
      list2iterate = data.supply_dept;
      sectionTitle = "Запрос ресурсов из другого департамента";
      break;
    case "INFO":
      list2iterate = data.info_dept;
      sectionTitle = "доклад информации другому департаменту";
      break;
  }
  return (
    <Section title={sectionTitle} buttons={
      <Button
        content="Обратно"
        icon="arrow-left"
        onClick={
          () => act('setScreen', { setScreen: 0 })
        } />
    }>
      <LabeledList>
        {list2iterate.filter(d => (d !== department)).map(d => (
          <LabeledList.Item key={d} label={d}>
            <Button
              content="Сообщение"
              icon="envelope"
              onClick={
                () => act('writeInput', { write: d, priority: 1 })
              } />
            <Button
              content="Высокий приоритет"
              icon="exclamation-circle"
              onClick={
                () => act('writeInput', { write: d, priority: 2 })
              } />
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  );
};

const MessageResponse = (props, context) => {
  const { act, data } = useBackend(context);

  let sectionTitle;
  switch (props.type) {
    case "SUCCESS":
      sectionTitle = "Сообщение успешно отправлено";
      break;
    case "FAIL":
      sectionTitle = "Запрос ресурсов из другого департамента";
      break;
  }

  return (
    <Section title={sectionTitle} buttons={
      <Button
        content="Обратно"
        icon="arrow-left"
        onClick={
          () => act('setScreen', { setScreen: 0 })
        } />
    } />
  );
};

const MessageLog = (props, context) => {
  const { act, data } = useBackend(context);

  let list2iterate;
  let sectionTitle;
  switch (props.type) {
    case "MESSAGES":
      list2iterate = data.message_log;
      sectionTitle = "Журнал сообщений";
      break;
    case "SHIPPING":
      list2iterate = data.shipping_log;
      sectionTitle = "Журнал печати упаковок";
      break;
  }

  return (
    <Section title={sectionTitle} buttons={
      <Button
        content="Обратно"
        icon="arrow-left"
        onClick={
          () => act('setScreen', { setScreen: 0 })
        } />
    } >
      {list2iterate.map(m => (
        <Box className="RequestConsole__message" key={m}>
          {m}
        </Box>
      ))}
    </Section>
  );
};

const MessageAuth = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    recipient,
    message,
    msgVerified,
    msgStamped,
  } = data;

  return (
    <Section title="Идентификация сообщений" buttons={
      <Button
        content="Обратно"
        icon="arrow-left"
        onClick={
          () => act('setScreen', { setScreen: 0 })
        } />
    } >
      <LabeledList>
        <LabeledList.Item label="Принимающий">
          {recipient}
        </LabeledList.Item>
        <LabeledList.Item label="Сообщение">
          {message}
        </LabeledList.Item>
        <LabeledList.Item label="Подтверждено" color="green">
          {msgVerified}
        </LabeledList.Item>
        <LabeledList.Item label="Проштамповано" color="blue">
          {msgStamped}
        </LabeledList.Item>
      </LabeledList>
      <Button
        fluid
        mt={1}
        textAlign="center"
        content="Отправить сообщение"
        icon="envelope"
        onClick={
          () => act('department', { department: recipient })
        } />
    </Section>
  );
};

const StationAnnouncement = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    message,
    announceAuth,
  } = data;

  return (
    <Section title="Уведомление по станции" buttons={
      <Button
        content="Обратно"
        icon="arrow-left"
        onClick={
          () => act('setScreen', { setScreen: 0 })
        } />
    } >
      <Button
        content={message ? message : "Редактировать сообщение"}
        icon="edit"
        onClick={
          () => act('writeAnnouncement')
        } />
      {announceAuth ? (
        <Box mt={1} color="green">
          ID verified. Authentication accepted.
        </Box>
      ) : (
        <Box mt={1}>
          Swipe your ID card to authenticate yourself.
        </Box>
      )}
      <Button
        fluid
        mt={1}
        textAlign="center"
        content="Отправить уведомление"
        icon="bullhorn"
        disabled={!(announceAuth && message)}
        onClick={
          () => act('sendAnnouncement')
        } />
    </Section>
  );
};

const PrintShippingLabel = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    shipDest,
    msgVerified,
    ship_dept,
  } = data;

  return (
    <Section title="Распечатать доставочную упаковку" buttons={
      <Button
        content="Back"
        icon="arrow-left"
        onClick={
          () => act('setScreen', { setScreen: 0 })
        } />
    } >
      <LabeledList>
        <LabeledList.Item label="Пункт назначения">
          {shipDest}
        </LabeledList.Item>
        <LabeledList.Item label="Подтверждено">
          {msgVerified}
        </LabeledList.Item>
      </LabeledList>
      <Button
        fluid
        mt={1}
        textAlign="center"
        content="Распечатать упаковку"
        icon="print"
        disabled={!(shipDest && msgVerified)}
        onClick={
          () => act('printLabel')
        } />
      <Section title="Пункты назначения" mt={1}>
        <LabeledList>
          {ship_dept.map(d => (
            <LabeledList.Item label={d} key={d}>
              <Button
                content={shipDest === d ? "Выбрано" : "Выбрать"}
                selected={shipDest === d}
                onClick={
                  () => act('shipSelect', { shipSelect: d })
                } />
            </LabeledList.Item>
          ))}
        </LabeledList>
      </Section>
    </Section>
  );
};
